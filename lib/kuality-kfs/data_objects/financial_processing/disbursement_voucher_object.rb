class DisbursementVoucherObject < KFSDataObject

  include PaymentInformationMixin
  include AccountingLinesMixin

  alias :add_target_line :add_source_line
  alias :import_target_lines :import_source_lines

  DOC_INFO = { label: 'Disbursement Voucher Document', type_code: 'DV' }

                # == Document Overview (Move to KFSDataObject?) ==
  attr_accessor :organization_document_number, :explanation,
                # == Contact Information Tab ==
                :contact_name, :phone_number, :email_address,
                # == Foreign Draft Tab ==
                :foreign_draft_in_usd, :foreign_draft_in_foreign_currency, :currency_type,
                # == Non-Employee Travel Expense Tab ==
                :car_mileage, :car_mileage_reimb_amt, :per_diem_start_date,
                # == Pre-Paid Travel Expense Tab ==
                :pre_paid_travel_location, :pre_paid_travel_type, :pre_paid_travel_start_date, :pre_paid_travel_end_date, :pre_paid_travel_expenses,
                # == Nonresident Alien Tax Tab ==
                :nra_income_class_code, :nra_federal_income_tax_pct, :nra_state_income_tax_pct, :nra_country_code


  def defaults
    {
      description:              random_alphanums(40, 'AFT'),
      pre_paid_travel_expenses: collection('ExpenseLineObject')
      #foreign_draft_in_foreign_currency: :set,
      #currency_type:                     'Canadian $'
    }
  end

  def initialize(browser, opts={})
    @browser = browser
    set_options(defaults.merge!(default_accounting_lines)
                        .merge!(default_payment_information_lines)
                        .merge(get_aft_parameter_values_as_hash(ParameterConstants::DEFAULTS_FOR_DISBURSEMENT_VOUCHER))
                        .merge(opts))
  end

  def build
    visit(MainPage).disbursement_voucher
    on DisbursementVoucherPage do |page|
      page.expand_all
      page.description.focus
      page.alert.ok if page.alert.exists? # Because, y'know, sometimes it doesn't actually come up...

      @phone_number = page.phone_number.value.strip if @phone_number.nil? # Grab the phone number on the page if no update is supplied
      @phone_number = random_phone_number if @phone_number.nil? || @phone_number.empty? || @phone_number == 'null' # Make up a phone number if there still isn't one.

      fill_out page, :description, :organization_document_number, :explanation,
                     :contact_name, :phone_number, :email_address,
                     :car_mileage, :car_mileage_reimb_amt, :per_diem_start_date,
                     :foreign_draft_in_usd, :foreign_draft_in_foreign_currency, :currency_type

      supplied_ppt_expenses = @pre_paid_travel_expenses
      @pre_paid_travel_expenses = defaults[:pre_paid_travel_expenses] # Having to reinitialize the collection is a little annoying, but necessary.
      add_pre_paid_travel({
                            pre_paid_travel_location:   @pre_paid_travel_location,
                            pre_paid_travel_type:       @pre_paid_travel_type,
                            pre_paid_travel_start_date: @pre_paid_travel_start_date,
                            pre_paid_travel_end_date:   @pre_paid_travel_end_date,
                            pre_paid_travel_expenses:   supplied_ppt_expenses
                          })
      add_nonresident_alien_tax({
                                  income_class_code:      @nra_income_class_code,
                                  federal_income_tax_pct: @nra_federal_income_tax_pct,
                                  state_income_tax_pct:   @nra_state_income_tax_pct,
                                  country_code:           @nra_country_code
                                })
    end
  end

  def update(opts={})
    on DisbursementVoucherPage do |page|
      page.expand_all
      edit_payment_info opts # Must come first in case we change the payment method
      edit_fields opts, page, :description, :organization_document_number, :explanation,
                              :contact_name, :phone_number, :email_address,
                              :car_mileage, :car_mileage_reimb_amt, :per_diem_start_date,
                              :foreign_draft_in_usd, :foreign_draft_in_foreign_currency, :currency_type
      add_pre_paid_travel opts
      add_nonresident_alien_tax opts
    end
    update_options(opts)
  end
  alias_method :edit, :update

  def add_pre_paid_travel(opts={})
    on PrePaidTravelExpensesTab do |tab|
      tab.show_pre_paid_travel_expense_tab unless tab.pre_paid_travel_expense_tab_shown?

      overview = {
          location:   opts[:pre_paid_travel_location],
          type:       opts[:pre_paid_travel_type],
          start_date: opts[:pre_paid_travel_start_date],
          end_date:   opts[:pre_paid_travel_end_date]
      }.delete_if{ |k, v| v.nil? }

      edit_fields overview, tab, :location, :type, :start_date, :end_date unless overview.empty?
      unless opts[:pre_paid_travel_expenses].nil?
        @pre_paid_travel_expenses.edit opts[:pre_paid_travel_expenses]
        opts.delete(:pre_paid_travel_expenses)
      end
      update_options(opts.select{ |k,v| overview.keys.include? k })
    end
  end

  def add_nonresident_alien_tax(opts={})
    on NonresidentAlienTaxTab do |tab|
      tab.show_nonresident_alien_tax_tab unless tab.nonresident_alien_tax_tab_shown?

      nra_tax = {
          income_class_code:      opts[:nra_income_class_code],
          federal_income_tax_pct: opts[:nra_federal_income_tax_pct],
          state_income_tax_pct:   opts[:nra_state_income_tax_pct],
          country_code:           opts[:nra_country_code]
      }.delete_if{ |k, v| v.nil? }

      unless nra_tax.empty?
        edit_fields nra_tax, tab, :income_class_code, :federal_income_tax_pct, :state_income_tax_pct, :country_code
        tab.generate_line
        update_options(opts.select{ |k,v| nra_tax.keys.include? k })
      end
    end
  end

  def calculate_nete_pv_mileage
    on(DisbursementVoucherPage).calc_mileage_amount
  end

end