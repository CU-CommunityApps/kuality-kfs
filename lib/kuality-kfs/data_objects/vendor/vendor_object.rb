class VendorObject < KFSDataObject

  include AddressLinesMixin
  include PhoneNumberLinesMixin
  include ContactLinesMixin
  include ContractLinesMixin
  include SearchAliasLinesMixin
  include SupplierDiversityLinesMixin

  DOC_INFO = { label: 'Vendor', type_code: 'PVEN', transactional?: false, action_wait_time: 30 }

  attr_accessor :vendor_number, :vendor_name, :vendor_last_name, :vendor_first_name,
                :vendor_type, :foreign, :tax_number,
                :tax_number_type_fein, :tax_number_type_ssn, :tax_number_type_none,
                :ownership, :w9_received,
                #== Extended Attributes ===
                :w9_received_date, :default_payment_method,
                # == Insurance Tracking Tab (wouldn't hurt to break it off eventually) ==
                :general_liability_coverage_amt, :general_liability_expiration_date,
                :automobile_liability_coverage_amt, :automobile_liability_expiration_date,
                :workman_liability_coverage_amt,:workman_liability_expiration_date,
                :excess_liability_umb_amt, :excess_liability_umb_expiration_date,
                :health_offset_lic_expiration_date, :health_offsite_catering_lic_req,
                :cornell_additional_ins_ind, :insurance_note,
                :insurance_requirements_complete, :insurance_requirement_indicator

  def defaults
    super.merge({
      vendor_type:         'PO - PURCHASE ORDER',
      vendor_name:         'Keith, inc',
      foreign:             'No',
      tax_number:          random_tax_number,
      tax_number_type_ssn: :set, # If this default is changed, you must update #sync_tax_number_type
      ownership:           'INDIVIDUAL/SOLE PROPRIETOR',
      w9_received:         'Yes'
    }).merge(default_addresses)
      .merge(default_contacts)
      .merge(default_contracts)
      .merge(default_phone_numbers)
      .merge(default_search_aliases)
      .merge(get_aft_parameter_values_as_hash(ParameterConstants::DEFAULTS_FOR_VENDOR))
  end

  def build
    visit(MainPage).vendor
    on(VendorLookupPage).create_new
    on VendorPage do |page|
      page.expand_all
      page.description.focus
      page.alert.ok if page.alert.exists? # Because, y'know, sometimes it doesn't actually come up...

      sync_tax_number_type

      fill_out page, :description,
                     :vendor_name, :vendor_last_name, :vendor_first_name,
                     :vendor_type, :foreign, :tax_number,
                     :tax_number_type_fein, :tax_number_type_ssn, :tax_number_type_none,
                     :ownership, :w9_received
    end
  end

  def absorb!(target=:new)
    super
    on(VendorPage).expand_all
    case target
      when :new; update_options(pull_new_vendor_data)
      when :old; update_options(pull_old_vendor_data)
    end

    update_line_objects_from_page!(target)
  end

  # @return [Hash] The return values of attributes for the old Vendor
  def pull_old_vendor_data
    pulled_vendor = Hash.new
    on VendorPage do |vp|
      pulled_vendor = {
        vendor_number: vp.old_vendor_number,
        vendor_name:   vp.old_vendor_name.empty? ? "#{vp.old_vendor_last_name}, #{vp.old_vendor_first_name}" : vp.old_vendor_name,
        vendor_last_name:  vp.old_vendor_last_name,
        vendor_first_name: vp.old_vendor_first_name,
        vendor_type: vp.old_vendor_type,
        foreign:     vp.old_foreign,
        tax_number:  vp.old_tax_number,
        tax_number_type_fein: vp.old_tax_number_type_fein,
        tax_number_type_ssn:  vp.old_tax_number_type_ssn,
        tax_number_type_none: vp.old_tax_number_type_none,
        ownership:   vp.old_ownership,
        w9_received: vp.old_w9_received
      }
    end
    pulled_vendor.merge(pull_vendor_extended_data(:old))
  end

  # @return [Hash] The return values of attributes for the new Vendor
  def pull_new_vendor_data
    pulled_vendor = Hash.new
    on VendorPage do |vp|
      pulled_vendor = {
          vendor_number: vp.new_vendor_number,
          vendor_name: vp.new_vendor_name.value.strip,
          vendor_last_name:  vp.new_vendor_last_name.value.strip,
          vendor_first_name: vp.new_vendor_first_name.value.strip,
          vendor_type: vp.new_vendor_type.value.strip,
          foreign:     vp.new_foreign.selected_options.first.text.strip,
          tax_number:  vp.new_tax_number.value.strip,
          tax_number_type_fein: vp.new_tax_number_type_fein.value.strip,
          tax_number_type_ssn:  vp.new_tax_number_type_ssn.value.strip,
          tax_number_type_none: vp.new_tax_number_type_none.value.strip,
          ownership:   vp.new_ownership.selected_options.first.text.strip,
          w9_received: vp.new_w9_received.selected_options.first.text.strip
      }
    end
    pulled_vendor.merge(pull_vendor_extended_data(:new))
  end


  def extended_defaults
    { default_payment_method: 'P - ACH/CHECK', w9_received_date: yesterday[:date_w_slashes] }.merge(default_supplier_diversities)
  end

  def fill_out_extended_attributes
    on(VendorPage) do |page|
      fill_out page, :w9_received_date, :default_payment_method,
               :general_liability_coverage_amt, :general_liability_expiration_date,
               :automobile_liability_coverage_amt, :automobile_liability_expiration_date,
               :workman_liability_coverage_amt, :workman_liability_expiration_date,
               :excess_liability_umb_amt, :excess_liability_umb_expiration_date,
               :health_offset_lic_expiration_date, :health_offsite_catering_lic_req,
               :cornell_additional_ins_ind, :insurance_note,
               :insurance_requirements_complete, :insurance_requirement_indicator
    end
  end

  # @return [Hash] The return values of extended attributes for the old Vendor
  # @param [Symbol] target The set of Vendor data to pull in
  def pull_vendor_extended_data(target=:new)
    pulled_vendor = Hash.new
    on VendorPage do |vp|
      case target
        when :old
          pulled_vendor = {
              w9_received_date: vp.old_w9_received_date,
              default_payment_method: vp.old_default_payment_method,
              general_liability_coverage_amt:       vp.old_general_liability_coverage_amt,
              general_liability_expiration_date:    vp.old_general_liability_expiration_date,
              automobile_liability_coverage_amt:    vp.old_automobile_liability_coverage_amt,
              automobile_liability_expiration_date: vp.old_automobile_liability_expiration_date,
              workman_liability_coverage_amt:       vp.old_workman_liability_coverage_amt,
              workman_liability_expiration_date:    vp.old_workman_liability_expiration_date,
              excess_liability_umb_amt: vp.old_excess_liability_umb_amt,
              excess_liability_umb_expiration_date: vp.old_excess_liability_umb_expiration_date,
              health_offset_lic_expiration_date:    vp.old_health_offset_lic_expiration_date,
              insurance_note: vp.old_insurance_note,
              cornell_additional_ins_ind:      vp.old_cornell_additional_ins_ind,
              health_offsite_catering_lic_req: vp.old_health_offsite_catering_lic_req,
              insurance_requirements_complete: vp.old_insurance_requirements_complete,
              insurance_requirement_indicator: yesno2setclear(vp.old_insurance_requirement_indicator)
          }
        when :new
          pulled_vendor = {
              w9_received_date: vp.new_w9_received_date.value.strip,
              default_payment_method: vp.new_default_payment_method.value.strip,
              general_liability_coverage_amt:       vp.new_general_liability_coverage_amt.value.strip,
              general_liability_expiration_date:    vp.new_general_liability_expiration_date.value.strip,
              automobile_liability_coverage_amt:    vp.new_automobile_liability_coverage_amt.value.strip,
              automobile_liability_expiration_date: vp.new_automobile_liability_expiration_date.value.strip,
              workman_liability_coverage_amt:       vp.new_workman_liability_coverage_amt.value.strip,
              workman_liability_expiration_date:    vp.new_workman_liability_expiration_date.value.strip,
              excess_liability_umb_amt: vp.new_excess_liability_umb_amt.value.strip,
              excess_liability_umb_expiration_date: vp.new_excess_liability_umb_expiration_date.value.strip,
              health_offset_lic_expiration_date:    vp.new_health_offset_lic_expiration_date.value.strip,
              insurance_note: vp.new_insurance_note.value.strip,
              cornell_additional_ins_ind:      vp.new_cornell_additional_ins_ind.selected_options.first.text.strip,
              health_offsite_catering_lic_req: vp.new_health_offsite_catering_lic_req.selected_options.first.text.strip,
              insurance_requirements_complete: vp.new_insurance_requirements_complete.selected_options.first.text.strip,
              insurance_requirement_indicator: yesno2setclear(vp.new_insurance_requirement_indicator.value.strip)
          }
      end
    end
    pulled_vendor
  end

  private

  # We want the tax number types to either be :set or nil but only one can
  # be :set at a time since this is a radio. This should update the other two
  # when one is set.
  def sync_tax_number_type
    if @tax_number_type_fein == :set
      @tax_number_type_ssn = nil
      @tax_number_type_none = nil
    elsif @tax_number_type_ssn == :set
      @tax_number_type_fein = nil
      @tax_number_type_none = nil
    elsif @tax_number_type_none == :set
      @tax_number_type_ssn = nil
      @tax_number_type_fein = nil
    end
  end

end