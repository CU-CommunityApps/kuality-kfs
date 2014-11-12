class ContractLineObject < DataFactory

  include DateFactory
  include StringFactory
  include GlobalConfig

  attr_accessor   :line_number,
                  :number, :name,
                  :description, :campus_code,
                  :begin_date, :end_date,
                  :manager, :po_cost_source,
                  :b2b, :payment_terms,
                  :shipping_terms, :shipping_title,
                  :extension_option_date, :default_apo_limit,
                  :active

  def initialize(browser, opts={})
    @browser = browser

    defaults = { active: :set }

    set_options(defaults.merge(opts))
  end

  def create
    # For now, this only supports Vendor. We'll need to refactor appropriately
    # if any other object needs this collection.
    on VendorPage do |vp|
      raise ArgumentError, 'Contract Numbers cannot be modified.' unless @number.nil?
      vp.new_contract_name.fit                  @name
      vp.new_contract_description.fit           @description
      vp.new_contract_campus_code.pick!         @campus_code
      vp.new_contract_begin_date.fit            @begin_date
      vp.new_contract_end_date.fit              @end_date
      vp.new_contract_manager.pick!             @manager
      vp.new_contract_po_cost_source.pick!      @po_cost_source
      vp.new_b2b_contract_indicator.pick        @b2b
      vp.new_contract_payment_terms.pick!       @payment_terms
      vp.new_contract_shipping_terms.pick!      @shipping_terms
      vp.new_contract_shipping_title.pick!      @shipping_title
      vp.new_contract_extension_option_date.fit @extension_option_date
      vp.new_contract_default_apo_limit.fit     @default_apo_limit
      vp.new_contact_active_indicator.fit       @active
      fill_out_extended_attributes
      vp.add_contract
      @number = vp.contract_number_new(vp.current_contracts_count - 1) # Contracts get tacked onto the end
    end
  end

  def edit(opts={})
    on VendorPage do |vp|
      raise ArgumentError, 'Contract Numbers cannot be modified.' unless opts[:number].nil?
      vp.contract_name_update(@line_number).fit                  opts[:name]
      vp.contract_description_update(@line_number).fit           opts[:description]
      vp.contract_campus_code_update(@line_number).pick!         opts[:campus_code]
      vp.contract_begin_date_update(@line_number).fit            opts[:begin_date]
      vp.contract_end_date_update(@line_number).fit              opts[:end_date]
      vp.contract_manager_update(@line_number).pick!             opts[:manager]
      vp.contract_po_cost_source_update(@line_number).pick!      opts[:po_cost_source]
      vp.b2b_contract_indicator_update(@line_number).pick!       opts[:b2b]
      vp.contract_payment_terms_update(@line_number).pick!       opts[:payment_terms]
      vp.contract_shipping_terms_update(@line_number).pick!      opts[:shipping_terms]
      vp.contract_shipping_title_update(@line_number).pick!      opts[:shipping_title]
      vp.contract_extension_option_date_update(@line_number).fit opts[:extension_option_date]
      vp.contract_default_apo_limit_update(@line_number).fit     opts[:default_apo_limit]
      vp.contract_active_indicator_update(@line_number).fit      opts[:active]
    end
    update_options(opts)
    update_extended_attributes(opts)
  end

  def delete
    on(VendorPage).delete_contract @line_number
  end

  def fill_out_extended_attributes
    # Override this method if you have site-specific extended attributes.
  end

  def update_extended_attributes(opts = {})
    # Override this method if you have site-specific extended attributes.
  end
  alias_method :edit_extended_attributes, :update_extended_attributes

end

class ContractLineObjectCollection < LineObjectCollection

  contains ContractLineObject

  def update_from_page!(target=:new)
    on VendorPage do |lines|
      clear # Drop any cached lines. More reliable than sorting out an array merge.

      lines.expand_all
      unless lines.current_contracts_count.zero?
        (0..(lines.current_contracts_count - 1)).to_a.collect!{ |i|
          pull_existing_contract(i, target).merge(pull_extended_existing_contract(i, target))
        }.each { |new_obj|
          # Update the stored lines
          self << (make contained_class, new_obj)
        }
      end

    end
  end

  # @param [Fixnum] i The line number to look for (zero-based)
  # @param [Symbol] target Which contract to pull from (most useful during a copy action). Defaults to :new
  # @return [Hash] The return values of attributes for the given line
  def pull_existing_contract(i=0, target=:new)
    pulled_contract = Hash.new

    on VendorPage do |vp|
      case target
        when :old
          pulled_contract = {
            number:                vp.contract_number_old(i),
            name:                  vp.contract_name_old(i),
            description:           vp.contract_description_old(i),
            campus_code:           vp.contract_campus_code_old(i),
            begin_date:            vp.contract_begin_date_old(i),
            end_date:              vp.contract_end_date_old(i),
            manager:               vp.contract_manager_old(i),
            po_cost_source:        vp.contract_po_cost_source_old(i),
            b2b:                   vp.b2b_contract_indicator_old(i),
            payment_terms:         vp.contract_payment_terms_old(i),
            shipping_terms:        vp.contract_shipping_terms_old(i),
            shipping_title:        vp.contract_shipping_title_old(i),
            extension_option_date: vp.contract_extension_option_date_old(i),
            default_apo_limit:     vp.contract_default_apo_limit_old(i),
            active:                yesno2setclear(vp.contract_active_indicator_old(i))
          }
        when :new
          pulled_contract = {
              number:                vp.contract_number_new(i),
              name:                  vp.contract_name_new(i),
              description:           vp.contract_description_new(i),
              campus_code:           vp.contract_campus_code_new(i),
              begin_date:            vp.contract_begin_date_new(i),
              end_date:              vp.contract_end_date_new(i),
              manager:               vp.contract_manager_new(i),
              po_cost_source:        vp.contract_po_cost_source_new(i),
              b2b:                   vp.b2b_contract_indicator_new(i),
              payment_terms:         vp.ontract_payment_terms_new(i),
              shipping_terms:        vp.contract_shipping_terms_new(i),
              shipping_title:        vp.contract_shipping_title_new(i),
              extension_option_date: vp.contract_extension_option_date_new(i),
              default_apo_limit:     vp.contract_default_apo_limit_new(i),
              active:                yesno2setclear(vp.contract_active_indicator_new(i))
          }
      end
    end

    pulled_contract
  end

  # @param [Fixnum] i The line number to look for (zero-based)
  # @param [Symbol] target Which contract to pull from (most useful during a copy action). Defaults to :new
  # @return [Hash] The return values of attributes for the given line
  def pull_extended_existing_contract(i=0, target=:new)
    # This can be implemented for site-specific attributes. See the Hash returned in
    # the #collect! in #update_from_page! above for the kind of way to get the
    # right return value.
    Hash.new
  end

end