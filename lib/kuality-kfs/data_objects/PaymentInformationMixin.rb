module PaymentInformationMixin

  include DateFactory
  include Utilities
  include GlobalConfig

  attr_accessor :payee_id, :payee_name,
                :address_1, :address_2, :city, :state, :country,
                :postal_code, :check_amount, :due_date,
                :other_considerations_check_enclosure, :other_considerations_special_handling,
                :other_considerations_w9_completed, :other_considerations_exception_attached,
                :other_considerations_immediate_payment_indicator, :payment_method,
                :documentation_location_code, :check_stub_text,
                :address_type_description, :vendor_payee
  attr_reader   :payment_reason_code

  def payment_reason_code=(prc)
    if prc.length == 1
      @payment_reason_code = self.class.decode_reason_code(prc)
    else
      @payment_reason_code = prc
    end
  end

  alias :vendor_payee? :vendor_payee
  def default_payment_information_lines(opts={})
    {
        payment_reason_code: 'B - Reimbursement for Out-of-Pocket Expenses',
        check_amount:        '100.00',
        #due_date:            '',
        #other_considerations_check_enclosure:    '',
        #other_considerations_special_handling:   '',
        #other_considerations_w9_completed:       '',
        #other_considerations_exception_attached: '',
        #other_considerations_immediate_payment_indicator: '',
        payment_method:              'P - ACH/CHECK',#'F - Foreign Draft',
        #documentation_location_code: '',
        check_stub_text:             'test, Check Stub',
        address_type_description:    'TX - TAX',
        vendor_payee:                true
    }.merge(opts)
  end

  def post_create
    super
    unless @payee_id.nil?
      choose_payee
      fill_in_payment_info
    end
  end

  # Fills in information directly on the PaymentInformationTab and absorbs values supplied by choosing a payee previously.
  def fill_in_payment_info
    on PaymentInformationTab do |tab|
      # These are returned to the page by choose_payee
      @payment_reason_code = tab.payment_reason_code
      @payee_name = tab.payee_name
      @address_1 = tab.address_1.value
      @address_2 = tab.address_2.value
      @city = tab.city.value
      @state = tab.state.value
      @country = tab.country.selected_options.first.text
      @postal_code = tab.postal_code.value
      @due_date = tab.due_date.value
      @other_considerations_check_enclosure = (tab.other_considerations_check_enclosure.exists? ? tab.other_considerations_check_enclosure.value : 'No')
      @other_considerations_special_handling = (tab.other_considerations_special_handling.exists? ? tab.other_considerations_special_handling.value : 'No')
      @other_considerations_w9_completed = (tab.other_considerations_w9_completed.exists? ? tab.other_considerations_w9_completed.value : 'No')
      @other_considerations_exception_attached = (tab.other_considerations_exception_attached.exists? ? tab.other_considerations_exception_attached.value : 'No')
      @other_considerations_immediate_payment_indicator = (tab.other_considerations_immediate_payment_indicator.exists? ? tab.other_considerations_immediate_payment_indicator.value : 'No')
      @documentation_location_code = tab.documentation_location_code.selected_options.first.text

      fill_out tab, :payment_method
      tab.alert.ok if tab.alert.exists? # popup after select 'Foreign draft'
      fill_out tab, :check_amount, :documentation_location_code, :check_stub_text
    end
  end

  # Edits information directly on the PaymentInformationTab. Not for updating a Payee!
  # Also note that this doesn't call #update_options (in order to play nicely with #edit),
  # so you'll either want to do so after calling this, or simply use #edit instead.
  def edit_payment_info(opts={})
    payment_info_fields = [:address_1, :address_2,
                           :city, :state, :country, :postal_code, :due_date,
                           :check_amount, :documentation_location_code, :check_stub_text,
                           :other_considerations_check_enclosure, :other_considerations_special_handling,
                           :other_considerations_w9_completed, :other_considerations_exception_attached,
                           :other_considerations_immediate_payment_indicator, :documentation_location_code]
    on PaymentInformationTab do |tab|
      edit_fields opts, tab, :payment_method unless opts[:payment_method].nil?
      tab.alert.ok if tab.alert.exists? # popup after select 'Foreign draft'
      edit_fields opts, tab, *(opts.keys & payment_info_fields) unless (opts.keys & payment_info_fields).empty?
    end
    update_options(opts.select{ |k,v| payment_info_fields.include? k })
  end

  def edit_payee(opts={})
    edit opts
    choose_payee
    fill_in_payment_info # Necessary because some information is read-only
  end

  # NOTE: This will only really work if you know the @payee_id and @address_type_description!
  # @param [TrueClass] choose Whether to actually click the return item link or not
  def choose_payee(choose=true)
    if @payee_name == '::random::'
      vn = get_random_vendor['vendorName'][0]
      vn = "#{vn[0..19]}*" if vn.length > 20
      @payee_name = vn
    end

    on(PaymentInformationTab).payee_search unless on(Lookups).on_a_lookup? && (on(Lookups).lookup_title == 'Payee Lookup')
    on PayeeLookup do |plookup|
      plookup.payment_reason_code.fit @payment_reason_code unless @payment_reason_code.nil?
      plookup.vendor_name.fit @payee_name unless @payee_name.nil?


      if vendor_payee? # payee can be a 'vendor' or 'employee'
        plookup.vendor_number.fit @payee_id unless @payee_id.nil?
      else
        unless @payee_id.nil?
          if @payee_id == '::random::'
            plookup.netid.fit 'aa*' # Admittedly, this could be more random...
          else
            plookup.netid.fit @payee_id
          end
        end
      end

      plookup.search

      return unless choose # Exit here if we're not actually returning the value

      if @payee_id == '::random::' && !@vendor_payee
        # Pick the random payee's netid
        @payee_id = plookup.results_table
                           .rows
                           .sample[plookup.results_table
                                          .keyed_column_index(:netid)]
                           .text
      end

      if @payee_id.nil?
        plookup.return_value_links.first.click
      else
        plookup.return_value(@payee_id)
      end
    end

    if on(Lookups).on_a_lookup? && (on(Lookups).lookup_title == 'Vendor Address Lookup')
      on VendorAddressLookup do |valookup|
        valookup.address_1.fit @address_1 unless @address_1.nil?
        valookup.address_2.fit @address_2 unless @address_2.nil?
        valookup.city.fit @city unless @city.nil?
        valookup.state.fit @state unless @state.nil?
        valookup.country.fit @country unless @country.nil?
        valookup.postal_code.fit @postal_code unless @postal_code.nil?
        valookup.address_type.fit @address_type_description unless @address_type_description.nil?

        valookup.search
        valookup.return_value_links.first.click
      end
    end
  end

  # Implements #included so that we can inject anything from ClassMethods into the class that
  # includes the mixin.
  def self.included(base)
    base.extend(ClassMethods)
  end

  # Provides extended methods to whichever class includes the mixin.
  module ClassMethods

    # Gives the long version of a reason code based on its one letter identifier.
    def decode_reason_code(code)
      case code
        when 'B'
          'B - Reimbursement for Out-of-Pocket Expenses'
        when 'N'
          'N - Travel Payment for a Non-employee'
        when 'K'
          'K - Univ PettyCash Custodian Replenishment'
        else
          raise ArgumentError, "Supplied reason code (#{code}) is unknown. Expected a single-character code." if code.length > 1
          raise ArgumentError, "Supplied reason code (#{code}) is unknown."
      end
    end

  end

end