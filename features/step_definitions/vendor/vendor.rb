And /^I add a Contract to the Vendor document$/ do
  @vendor.contracts.add Hash.new # This relies on defaults being specified for a Contract. May need revision/replacement to be more useful.
end

And /^I edit a Vendor with Ownership Type (.*)$/ do |ownership_type|
  vendor_info = get_kuali_business_object('KFS-VND','VendorDetail','vendorHeader.vendorOwnershipCode=' + ownership_type)
  vendor_number = vendor_info['vendorNumber'][0]
  step "I edit a Vendor with Vendor Number #{vendor_number}"
end

When /^I close and save the Vendor document$/ do
  on(VendorPage).close
  on(YesOrNoPage).yes
end

And /^I lookup a Vendor with Vendor Number (.*)$/ do |vendor_number|
  visit(MainPage).vendor
  on VendorLookupPage do |page|
    page.active_indicator_yes.set
    page.vendor_number.fit vendor_number
    page.search
    page.edit_item vendor_number # This should throw a fail if the item isn't found.
  end
end

And /^I lookup a PO Vendor$/ do
  vendor_info = get_kuali_business_object('KFS-VND','VendorDetail','vendorHeader.vendorTypeCode=PO')
  vendor_number = vendor_info['vendorNumber'][0]

  step "I lookup a Vendor with Vendor Number #{vendor_number}"
end

And /^I lookup a PO Vendor with Supplier Diversity$/ do
  vendors = get_kuali_business_objects('KFS-VND','VendorDetail','vendorHeader.vendorOwnershipCode=ID&vendorHeader.vendorSupplierDiversities.vendorSupplierDiversityCode=WO&vendorHeader.vendorSupplierDiversities.extension.vendorSupplierDiversityExpirationDate=07/25/2014&active=Y&vendorNumber=*-0')
  vendor_info = vendors.values[0].sample
  until vendor_info['vendorNumber'][0].end_with? '-0'
    vendor_info = vendors.values[0].sample
  end
  vendor_number = vendor_info['vendorNumber'][0]

  step "I lookup a Vendor with Vendor Number #{vendor_number}"
end

And /^I edit a PO Vendor$/ do
  step 'I lookup a PO Vendor'
  @vendor = make VendorObject
  on(VendorPage).description.fit @vendor.description
  @vendor.absorb! :old
  @document_id = @vendor.document_id
end

And /^I lookup a Vendor with an active Contract$/ do
  vendor_contract = get_kuali_business_object('KFS-VND','VendorContract','active=Y&vendorDetailAssignedIdentifier=0')
  vendor_header_id = vendor_contract['vendorHeaderGeneratedIdentifier'].sample
  step "I lookup a Vendor with Vendor Number #{vendor_header_id}-0"
end

When /^I start a Purchase Order Vendor document with the following fields:$/ do |fields|
  fields = fields.to_data_object_attr
  raise ArgumentError, 'Invalid Tax Number Type provided!' unless (fields[:tax_number_type].upcase == 'FEIN' ||
      fields[:tax_number_type].upcase == 'SSN' ||
      fields[:tax_number_type].upcase == 'NONE')

  unless fields[:tax_number_type].nil?
    fields["tax_number_type_#{fields[:tax_number_type].downcase}".to_sym] = :set
    fields[:tax_number_type_fein] = nil if fields[:tax_number_type_fein].nil?
    fields[:tax_number_type_ssn] = nil if fields[:tax_number_type_ssn].nil?
    fields[:tax_number_type_none] = nil if fields[:tax_number_type_none].nil?
    fields.delete_if { |k, v| k == :tax_number_type }
  end

  fields[:w9_received_date] = to_standard_date(fields[:w9_received_date]) unless fields[:w9_received_date].nil?

  fields[:initial_addresses] = [{
                                    type:                      'PO - PURCHASE ORDER',
                                    address_1:                 '123 Main Street',
                                    address_2:                 '',
                                    attention:                 '',
                                    url:                       '',
                                    fax:                       '',
                                    province:                  '',
                                    city:                      'Ithaca',
                                    state:                     'NY',
                                    postal_code:               '14850',
                                    country:                   'United States',
                                    email:                     'ksa23@cornell.edu',
                                    set_as_default:            'Yes',
                                    active:                    :set,
                                    method_of_po_transmission: 'E-MAIL'
                                }] if fields[:initial_addresses].nil?

  @vendor = create VendorObject, fields
end
