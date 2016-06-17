class RequisitionObject < KFSDataObject

  DOC_INFO = { label: 'Requisition', type_code: 'REQS', transactional?: true, action_wait_time: 30 }

                # == eDoc Header area ==
  attr_accessor :requisition_id,
                # == Document Overview Tab ==
                # == Requisition Detail Section ==
                :payment_request_positive_approval_required,

                # == Delivery Tab ==
                :delivery_campus, :delivery_building,
                :delivery_address_1, :delivery_address_2,
                :delivery_room, :delivery_city,
                :delivery_state, :delivery_postal_code, :delivery_country,
                :delivery_to, :delivery_phone_number, :delivery_email,
                :delivery_date_required, :delivery_date_required_reason, :delivery_instructions,

                # == Vendor Tab (Incomplete) ==
                :vendor_notes,

                # == Additional Institutional Info Tab (Incomplete)==
                :requestor_phone

  def defaults
    super.merge(default_items)
         .merge(get_aft_parameter_values_as_hash(ParameterConstants::DEFAULTS_FOR_REQUISITION)) #parameter not defined as of 3/2016
  end

  def build
    visit(MainPage).requisition
    on RequisitionPage do |page|
      page.expand_all
      page.description.focus
      page.alert.ok if page.alert.exists?
      fill_out page, *((self.class.superclass.attributes -
                        self.class.superclass.read_only_attributes -
                        self.class.notes_and_attachments_tab_mixin_attributes) +
                       self.class.attributes -
                       self.class.read_only_attributes -
                       self.class.item_lines_mixin_attributes)

      # add_random_building_address if @delivery_building == '::random::'
      # # TODO: Define a way to pick a non-random Delivery Building for RequisitionObject
      #
      # process_initial_item_lines # Necessary here because we want to calculate after adding Items/Item Accounting Lines
      #
      # page.calculate
      #
      # @delivery_phone_number = @requestor_phone if @delivery_phone_number.nil?
      # fill_out page, :description, :payment_request_positive_approval_required,
      #                :delivery_instructions, :delivery_phone_number,
      #                :vendor_notes, :requestor_phone
    end
  end

  # Note: You'll need to update the subcollections separately.
  def update(opts={})
    on RequisitionPage do |page|
      edit_fields opts, page, :description, :payment_request_positive_approval_required,
                              :delivery_phone_number, :requestor_phone, :vendor_notes, :delivery_instructions
    end
    update_options(opts)
  end
  alias_method :edit, :update

  def save
    super
  end

  def submit
    super
  end

  def reload
    super
  end

  def calculate
    on(RequisitionPage).calculate
  end

  def absorb!(t=:new)
    super
    pulled_info = {}
    on RequisitionPage do |b|
      case t
        when :new
          pulled_info = {}
        when :readonly, :old
          pulled_info = {}
        else
          raise ArgumentError, "The provided target (#{t.inspect}) is not supported yet!"
      end

      pulled_info.merge!(pull_delivery_tab(t))

    end
    pulled_info.delete_if { |k, v| v.nil? }

    update_options(pulled_info)
    update_line_objects_from_page!(t)
  end

  def pull_delivery_tab(t=:new)
    pulled_delivery_info = {}
    on RequisitionPage do |b|
      case t
        when :new
          pulled_delivery_info = {
            delivery_campus:        b.delivery_campus_new,
            delivery_building:      b.delivery_building_new,
            delivery_address_1:     b.delivery_address_1_new,
            delivery_address_2:     b.delivery_address_2_new,
            delivery_room:          b.delivery_room_new,
            delivery_city:          b.delivery_city_new,
            delivery_state:         b.delivery_state_new,
            delivery_postal_code:   b.delivery_postal_code_new,
            delivery_country:       b.delivery_country_new,
            delivery_to:            b.delivery_to_new,
            delivery_phone_number:  b.delivery_phone_number_new,
            delivery_email:         b.delivery_email_new,
            delivery_date_required: b.delivery_date_required_new,  #(b.delivery_date_required.value if b.delivery_date_required.exists?),
            delivery_date_required_reason: b.delivery_date_required_reason_new,   #(b.delivery_date_required_reason.value if b.delivery_date_required_reason.exists?),
            delivery_instructions:  b.delivery_instructions_new  #(b.delivery_instructions.value if b.delivery_instructions.exists?)
          }
        when :readonly, :old
          pulled_delivery_info = {
              delivery_campus:        b.result_delivery_campus_readonly,
              delivery_building:      b.result_delivery_building_readonly,
              delivery_address_1:     b.result_delivery_address_1_readonly,
              delivery_address_2:     b.result_delivery_address_2_readonly,
              delivery_room:          b.result_delivery_room_readonly,
              delivery_city:          b.result_delivery_city_readonly,
              delivery_state:         b.result_delivery_state_readonly,
              delivery_postal_code:   b.result_delivery_postal_code_readonly,
              delivery_country:       b.result_delivery_country_readonly,
              delivery_to:            b.result_delivery_to_readonly,
              delivery_phone_number:  b.result_delivery_phone_number_readonly,
              delivery_email:         b.result_delivery_email_readonly,
              delivery_date_required: b.result_delivery_date_required_readonly,
              delivery_date_required_reason: b.result_delivery_date_required_reason_readonly,
              delivery_instructions:  b.result_delivery_instructions_readonly
          }
        else
          raise ArgumentError, "The provided target (#{t.inspect}) is not supported yet!"
      end
    end
    pulled_delivery_info.delete_if { |k, v| v.nil? }
  end

  include ItemLinesMixin

end