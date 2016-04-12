class RequisitionPage < KFSBasePage

# == REQUISITION DETAIL ==
  element(:document_overview) { |b| b.frm.div(id: 'tab-DocumentOverview-div') }
  element(:financial_document_detail_section) { |b| b.document_overview.table(class: 'datatable', summary: 'KFS Detail Section') }
  element(:requisition_detail_section) { |b| b.document_overview.table(class: 'datatable', summary: /^Detail Section$/m) }

  action(:chart_org_search) { |b| b.requisition_detail_section.button(title: 'Search ' ).click } #there is space after search
  value(:chart_org_readonly) { |b| b.requisition_detail_section.rows[0].tds[0].text.strip }
  element(:payment_request_positive_approval_required) { |b| b.requisition_detail_section.checkbox(name: 'document.paymentRequestPositiveApprovalIndicator') }
  value(:result_payment_request_positive_approval_required) { |b| b.requisition_detail_section.rows[1].tds[1].text.strip }
  #value(:account_distribution_method) { |b| b.frm.table(class: 'datatable', summary: 'Detail Section').td(text: 'Proportional')}

# == Delivery Tab ==
  element(:delivery_tab) { |b| b.frm.table(summary: 'Final Delivery Section') }

  # Search buttons
  element(:building_search_button) { |b| b.frm.button(name: /deliveryBuildingCode/) }
  action(:building_search) { |b| b.building_search_button.click }
  element(:room_search_button) { |b| b.frm.button(name: /deliveryBuildingRoomNumber/) }
  action(:room_search) { |b| b.room_search_button.click }

  element(:delivery_address_2) { |b| b.delivery_tab.text_field(name: 'document.deliveryBuildingLine2Address') }
  element(:delivery_room) { |b| b.delivery_tab.text_field(name: 'document.deliveryBuildingRoomNumber') }
  element(:delivery_to) { |b| b.delivery_tab.text_field(name: 'document.deliveryToName') }
  element(:delivery_phone_number) { |b| b.delivery_tab.text_field(name: 'document.deliveryToPhoneNumber') }
  element(:delivery_email) { |b| b.delivery_tab.text_field(name: 'document.deliveryToEmailAddress') }
  element(:delivery_date_required) { |b| b.delivery_tab.text_field(name: 'document.deliveryRequiredDate') }
  element(:delivery_date_required_reason) { |b| b.delivery_tab.select(name: 'document.deliveryRequiredDateReasonCode') }
  element(:delivery_instructions) { |b| b.delivery_tab.textarea(name: 'document.deliveryInstructionText') }

  # New
  # delivery_campus_new is alias under Read-Only section as this value is not editable
  # delivery_building_new is alias under Read-Only section as this value is not editable
  # delivery_address_1_new is alias under Read-Only section as this value is not editable
  value(:delivery_address_2_new) { |b| b.delivery_address_2.exists? ? b.delivery_address_2.value : b.delivery_address_2_readonly }
  value(:delivery_room_new) { |b| b.delivery_room.exists? ? b.delivery_room.value : b.delivery_room_readonly }
  # delivery_city_new is alias under Read-Only section as this value is not editable
  # delivery_state_new is alias under Read-Only section as this value is not editable
  # delivery_postal_code_new is alias under Read-Only section as this value is not editable
  # delivery_country_new is alias under Read-Only section as this value is not editable
  value(:delivery_to_new) { |b| b.delivery_to.exists? ? b.delivery_to.value : b.delivery_to_readonly }
  value(:delivery_phone_number_new) { |b| b.delivery_phone_number.exists? ? b.delivery_phone_number.value : b.delivery_phone_number_readonly }
  value(:delivery_email_new) { |b| b.delivery_email.exists? ? b.delivery_email.value : b.delivery_email_readonly }
  value(:delivery_date_required_new) { |b| b.delivery_date_required.exists? ? b.delivery_date_required.value : b.delivery_date_required_readonly }
  value(:delivery_date_required_reason_new) { |b| b.delivery_date_required_reason.exists? ? b.delivery_date_required_reason.selected_options.first.text : b.delivery_date_required_reason_readonly }
  value(:delivery_instructions_new) { |b| b.delivery_instructions.exists? ? b.delivery_instructions.value : b.delivery_instructions_readonly }

  # Read-Only
  value(:delivery_campus_readonly) { |b| b.delivery_tab.rows[0].tds[0].text.strip }
  value(:delivery_building_readonly) { |b| b.delivery_tab.rows[1].tds[0].text.strip }
  value(:delivery_address_1_readonly) { |b| b.delivery_tab.rows[2].tds[0].text.strip }
  value(:delivery_address_2_readonly) { |b| b.delivery_tab.rows[3].tds[0].text.strip }
  value(:delivery_room_readonly) { |b| b.delivery_tab.rows[4].tds[0].text.strip }
  value(:delivery_city_readonly) { |b| b.delivery_tab.rows[5].tds[0].text.strip }
  value(:delivery_state_readonly) { |b| b.delivery_tab.rows[6].tds[0].text.strip }
  value(:delivery_postal_code_readonly) { |b| b.delivery_tab.rows[7].tds[0].text.strip }
  value(:delivery_country_readonly) { |b| b.delivery_tab.rows[8].tds[0].text.strip }
  value(:delivery_to_readonly) { |b| b.delivery_tab.rows[0].tds[1].text.strip }
  value(:delivery_phone_number_readonly) { |b| b.delivery_tab.rows[1].tds[1].text.strip }
  value(:delivery_email_readonly) { |b| b.delivery_tab.rows[2].tds[1].text.strip }
  value(:delivery_date_required_readonly) { |b| b.delivery_tab.rows[3].tds[1].text.strip }
  value(:delivery_date_required_reason_readonly) { |b| b.delivery_tab.rows[4].tds[1].text.strip }
  value(:delivery_instructions_readonly) { |b| b.delivery_tab.rows[5].tds[1].text.strip }

  alias_method :delivery_campus_new, :delivery_campus_readonly
  alias_method :delivery_building_new, :delivery_building_readonly
  alias_method :delivery_address_1_new, :delivery_address_1_readonly
  alias_method :delivery_city_new, :delivery_city_readonly
  alias_method :delivery_state_new, :delivery_state_readonly
  alias_method :delivery_postal_code_new, :delivery_postal_code_readonly
  alias_method :delivery_country_new, :delivery_country_readonly


# == VENDOR ==
  element(:vendor_name) { |b| b.frm.text_field(name: 'document.vendorName') }
  alias_method :suggested_vendor, :vendor_name
  action(:vendor_name_search) { |b| b.frm.table(class: 'datatable', summary: 'Vendor Section').button(name: /org\.kuali\.kfs\.vnd\.businessobject\.VendorDetail/).when_present.click }
  alias_method :suggested_vendor_search, :vendor_name_search
  action(:clear_vendor) {|b| b.frm.table(class: 'datatable', summary: 'Vendor Section').button(name: /clearVendor/).when_present.click }

  element(:vendor_city) { |b| b.frm.text_field(name: 'document.vendorCityName') }
  element(:vendor_state) { |b| b.frm.text_field(name: 'document.vendorStateCode') }
  element(:vendor_address) { |address_field_num=1, b| b.frm.text_field(name: "document.vendorLine#{address_field_num}Address") } #1 or 2
  element(:vendor_address_1) { |b| b.frm.text_field(name: 'document.vendorLine1Address') }
  element(:vendor_address_2) { |b| b.frm.text_field(name: 'document.vendorLine2Address') }
  element(:vendor_province) { |b| b.frm.text_field(name: 'document.vendorAddressInternationalProvinceName') }

  element(:vendor_postal_code) { |b| b.frm.text_field(name: 'document.vendorPostalCode') }
  alias_method :vendor_zipcode, :vendor_postal_code
  value(:postal_code_value) { |b| b.frm.table(summary: 'Final Delivery Section').tr(index: 0, text: /Postal Code:/).td.text }

  element(:vendor_attention) { |b| b.frm.text_field(name: 'document.vendorAttentionName') }
  element(:vendor_customer_number) { |b| b.frm.text_field(name: 'document.vendorCustomerNumber') }
  element(:vendor_email) { |b| b.frm.text_field(name: 'document.vendorEmailAddress') }
  element(:vendor_notes) { |b| b.frm.textarea(name: 'document.vendorNoteText') }
  alias_method :vendor_notes_to_vendor, :vendor_notes

  element(:vendor_fax) { |b| b.frm.text_field(name: 'document.vendorFaxNumber') }
  alias_method :vendor_fax_number, :vendor_fax

  element(:vendor_name_additional) { |field_number=1, b| b.frm.text_field(name: "document.alternate#{field_number}VendorName") }
  element(:vendor_name_1) { |b| b.frm.text_field(name: 'document.alternate1VendorName') }
  element(:vendor_name_2) { |b| b.frm.text_field(name: 'document.alternate2VendorName') }
  element(:vendor_name_3) { |b| b.frm.text_field(name: 'document.alternate3VendorName') }
  element(:vendor_name_4) { |b| b.frm.text_field(name: 'document.alternate4VendorName') }
  element(:vendor_name_5) { |b| b.frm.text_field(name: 'document.alternate5VendorName') }

# == VENDOR - ITEMS (See ItemsTab) ==

# == FREIGHT ==
  element(:freight_description) { |b| b.frm.textarea(name: 'document.item[0].itemDescription') }
  element(:freight_cost) { |b| b.frm.text_field(name: 'document.item[0].itemUnitPrice') }
  element(:freight_chart) { |b| b.frm.select(name: 'document.item[1].newSourceLine.chartOfAccountsCode') }
  element(:freight_account_number) { |b| b.frm.text_field(name: 'document.item[0].newSourceLine.accountNumber') }
  element(:freight_sub_account) { |b| b.frm.text_field(name: 'document.item[0].newSourceLine.subAccountNumber') }
  element(:freight_object) { |b| b.frm.text_field(name: 'document.item[0].newSourceLine.financialObjectCode') }
  element(:freight_sub_object) { |b| b.frm.text_field(name: 'document.item[0].newSourceLine.financialSubObjectCode') }
  element(:freight_project) { |b| b.frm.text_field(name: 'document.item[0].newSourceLine.projectCode') }
  element(:freight_org_ref_id) { |b| b.frm.text_field(name: 'document.item[0].newSourceLine.organizationReferenceId') }
  alias_method :freight_organization_reference_id, :freight_org_ref_id

#ITEM ACCOUNTING LINES
  #Has own page object items_tab.rb

# == TRADE IN ==
  p_element(:added_percent) { |index=0,item_index=0, b| b.frm.text_field(name: "document.item[#{item_index}].sourceAccountingLine[#{index}].accountLinePercent") }
  p_element(:added_amount) { |index=0, item_index=0, b| b.frm.text_field(name: "document.item[#{item_index}].sourceAccountingLine[#{index}].amount") }

  element(:trade_in_description) { |b| b.frm.textarea(name: 'document.item[1].itemDescription') }
  element(:trade_in_cost) { |b| b.frm.text_field(name: 'document.item[1].itemUnitPrice') }

  element(:trade_in_chart) { |b| b.frm.select(name: 'document.item[1].newSourceLine.chartOfAccountsCode') }
  element(:trade_in_account_number) { |b| b.frm.text_field(name: 'document.item[1].newSourceLine.accountNumber') }

  element(:trade_in_sub_account) { |b| b.frm.text_field(name: 'document.item[1].newSourceLine.subAccountNumber') }
  element(:trade_in_object) { |b| b.frm.text_field(name: 'document.item[1].newSourceLine.financialObjectCode') }
  element(:trade_in_sub_object) { |b| b.frm.text_field(name: 'document.item[1].newSourceLine.financialSubObjectCode') }
  element(:trade_in_project) { |b| b.frm.text_field(name: 'document.item[1].newSourceLine.projectCode') }
  element(:trade_in_org_ref_id) { |b| b.frm.text_field(name: 'document.item[1].newSourceLine.organizationReferenceId') }
  alias_method :trade_in_organization_reference_id, :trade_in_org_ref_id

  element(:trade_in_percent) { |b| b.frm.text_field(name: 'document.item[1].newSourceLine.accountLinePercent') }
  element(:trade_in_amount) { |b| b.frm.text_field(name: 'document.item[1].newSourceLine.amount') }
  action(:trade_in_add) { |b| b.frm.button(name: 'methodToCall.insertSourceLine.line1.anchoraccountingSourceAnchor').click }

# == FULL ORDER DISCOUNT ==
  element(:full_order_description) { |b| b.frm.textarea(name: 'document.item[2].itemDescription') }
  element(:full_order_cost) { |b| b.frm.text_field(name: 'document.item[2].itemUnitPrice') }

  element(:full_order_chart) { |b| b.frm.select(name: 'document.item[2].newSourceLine.chartOfAccountsCode') }
  element(:full_order_account) { |b| b.frm.text_field(name: 'document.item[2].newSourceLine.accountNumber') }
  element(:full_order_sub_account) { |b| b.frm.text_field(name: 'document.item[2].newSourceLine.subAccountNumber') }
  element(:full_order_object) { |b| b.frm.text_field(name: 'document.item[2].newSourceLine.financialObjectCode') }
  element(:full_order_sub_object) { |b| b.frm.text_field(name: 'document.item[2].newSourceLine.financialSubObjectCode') }
  element(:full_order_project) { |b| b.frm.text_field(name: 'document.item[2].newSourceLine.projectCode') }
  element(:full_order_org_ref_id) { |b| b.frm.text_field(name: 'document.item[2].newSourceLine.organizationReferenceId') }
  element(:full_order_percent) { |b| b.frm.text_field(name: 'document.item[2].newSourceLine.accountLinePercent') }
  element(:full_order_amount) { |b| b.frm.text_field(name: 'document.item[2].newSourceLine.amount') }
  action(:full_order_add) { |b| b.frm.button(name: 'methodToCall.insertSourceLine.line2.anchoraccountingSourceAnchor').click }

# == MISCELLANEOUS ==
  element(:misc_description) { |b| b.frm.textarea(name: 'document.item[3].itemDescription') }
  element(:misc_cost) { |b| b.frm.text_field(name: 'document.item[3].itemUnitPrice') }
  element(:misc_account_number) { |b| b.frm.text_field(name: 'document.item[3].newSourceLine.accountNumber') }
  element(:misc_sub_account) { |b| b.frm.text_field(name: 'document.item[3].newSourceLine.subAccountNumber') }
  element(:misc_object) { |b| b.frm.text_field(name: 'document.item[3].newSourceLine.financialObjectCode') }
  element(:misc_sub_object) { |b| b.frm.text_field(name: 'document.item[3].newSourceLine.financialSubObjectCode') }
  element(:misc_project) { |b| b.frm.text_field(name: 'document.item[3].newSourceLine.projectCode') }
  element(:misc_org_ref_id) { |b| b.frm.text_field(name: 'document.item[3].newSourceLine.organizationReferenceId') }
  alias_method :misc_organization_reference_id, :misc_org_ref_id

  element(:misc_percent) { |b| b.frm.text_field(name: 'document.item[3].newSourceLine.accountLinePercent') }
  element(:misc_amount) { |b| b.frm.text_field(name: 'document.item[3].newSourceLine.amount') }

# == CAPITAL ASSET ==
  element(:system_type) { |b| b.frm.select(name: 'document.capitalAssetSystemTypeCode') }
  element(:system_state) { |b| b.frm.select(name: 'document.capitalAssetSystemStateCode') }
  action(:select) { |b| b.frm.button(name: 'methodToCall.selectSystem').click }

  element(:asset_note) { |b| b.frm.textarea(name: 'document.purchasingCapitalAssetSystems[0].capitalAssetNoteText') }
  element(:asset_system_description) { |b| b.frm.textarea(name: 'document.purchasingCapitalAssetSystems[0].capitalAssetSystemDescription') }
#TODO different type/state selection has different manufacturer/model_number tag name
#  'document.purchasingCapitalAssetItems[0].purchasingCapitalAssetSystem.capitalAssetManufacturerName'
#  'document.purchasingCapitalAssetSystems[0].capitalAssetManufacturerName'

  element(:manufacturer) { |l=0, b| b.frm.text_field(name: /\[#{l}\](.purchasingCapitalAssetSystem)?.capitalAssetManufacturerName/, title: 'Manufacturer') }
  element(:model_number) { |l=0, b| b.frm.text_field(name: /\[#{l}\](.purchasingCapitalAssetSystem)?.capitalAssetModelDescription/, title: 'Model Number') }
  element(:asset_number) { |b| b.frm.text_field(name: 'document.purchasingCapitalAssetSystems[0].capitalAssetCountAssetNumber') }
  element(:transaction_type_code) { |b| b.frm.select(name: 'document.purchasingCapitalAssetItems[0].capitalAssetTransactionTypeCode') }
  action(:same_as_vendor) { |b| b.frm.button(alt: 'Manufacturer Same as Vendor').click }
  element(:add_asset_number) { |b| b.frm.text_field(name: 'document.purchasingCapitalAssetItems[0].newPurchasingItemCapitalAssetLine.capitalAssetNumber') }
  action(:add_asset) { |b| b.frm.button(alt: 'Insert an Item Capital Asset').click }

  # == PAYMENT INFO ==
  element(:recurring_payment_type) { |b| b.frm.select(name: 'document.recurringPaymentTypeCode') }
  element(:payment_from_date) { |b| b.frm.text_field(name: 'document.purchaseOrderBeginDate') }
  element(:payment_to_date) { |b| b.frm.text_field(name: 'document.purchaseOrderEndDate') }

# == Additional Institutional Info Tab ==
  element(:additional_inst_info_tab) { |b| b.frm.table(summary: 'Additional Section') }

  element(:method_of_po_transmission) { |b| b.frm.select(name: 'document.purchaseOrderTransmissionMethodCode') }
  element(:institution_name) { |b| b.frm.text_field(name: 'document.institutionContactName') }
  element(:institution_phone) { |b| b.frm.text_field(name: 'document.institutionContactPhoneNumber') }
  element(:institution_email) { |b| b.frm.text_field(name: 'document.institutionContactEmailAddress') }
  element(:po_total_limit) { |b| b.frm.text_field(name: 'document.purchaseOrderTotalLimit') }
  element(:requestor_name) { |b| b.frm.text_field(name: 'document.requestorPersonName') }
  element(:requestor_phone) { |b| b.frm.text_field(name: 'document.requestorPersonPhoneNumber') }
  element(:requestor_email) { |b| b.frm.text_field(name: 'document.requestorPersonEmailAddress') }
  element(:reference_1) { |b| b.frm.text_field(name: 'document.requisitionOrganizationReference1Text') }
  element(:reference_2) { |b| b.frm.text_field(name: 'document.requisitionOrganizationReference2Text') }
  element(:reference_3) { |b| b.frm.text_field(name: 'document.requisitionOrganizationReference3Text') }

  # New
  value(:method_of_po_transmission_new) { |b| b.method_of_po_transmission.exists? ? b.method_of_po_transmission.selected_options.first.text : b.method_of_po_transmission_readonly }
  # cost_source_new is alias under Read-Only section as this value is not editable
  value(:institution_name_new) { |b| b.institution_name.exists? ? b.institution_name.value : b.institution_name_readonly }
  value(:institution_phone_new) { |b| b.institution_phone.exists? ? b.institution_phone.value : b.institution_phone_readonly }
  value(:institution_email_new) { |b| b.institution_email.exists? ? b.institution_email.value : b.institution_email_readonly }
  value(:po_total_limit_new) { |b| b.po_total_limit.exists? ? b.po_total_limit.value : b.po_total_limit_readonly }
  value(:requestor_name_new) { |b| b.requestor_name.exists? ? b.requestor_name.value : b.requestor_name_readonly }
  value(:requestor_phone_new) { |b| b.requestor_phone.exists? ? b.requestor_phone.value : b.requestor_phone_readonly }
  value(:requestor_email_new) { |b| b.requestor_email.exists? ? b.requestor_email.value : b.requestor_email_readonly }
  value(:reference_1_new) { |b| b.reference_1.exists? ? b.reference_1.value : b.reference_1_readonly }
  value(:reference_2_new) { |b| b.reference_2.exists? ? b.reference_2.value : b.reference_2_readonly }
  value(:reference_3_new) { |b| b.reference_3.exists? ? b.reference_3.value : b.reference_3_readonly }

  # Read-Only
  value(:method_of_po_transmission_readonly) { |b| b.additional_inst_info_tab.rows[0].tds[0].text.strip }
  value(:cost_source_readonly) { |b| b.additional_inst_info_tab.rows[1].tds[0].text.strip }
  value(:institution_name_readonly) { |b| b.additional_inst_info_tab.rows[2].tds[0].text.strip }
  value(:institution_phone_readonly) { |b| b.additional_inst_info_tab.rows[3].tds[0].text.strip }
  value(:institution_email_readonly) { |b| b.additional_inst_info_tab.rows[4].tds[0].text.strip }
  value(:po_total_limit_readonly) { |b| b.additional_inst_info_tab.rows[5].tds[0].text.strip }
  value(:requestor_name_readonly) { |b| b.additional_inst_info_tab.rows[0].tds[1].text.strip }
  value(:requestor_phone_readonly) { |b| b.additional_inst_info_tab.rows[1].tds[1].text.strip }
  value(:requestor_email_readonly) { |b| b.additional_inst_info_tab.rows[2].tds[1].text.strip }
  value(:reference_1_readonly) { |b| b.additional_inst_info_tab.rows[3].tds[1].text.strip }
  value(:reference_2_readonly) { |b| b.additional_inst_info_tab.rows[4].tds[1].text.strip }
  value(:reference_3_readonly) { |b| b.additional_inst_info_tab.rows[5].tds[1].text.strip }

  alias_method :cost_source_new, :cost_source_readonly

# == VIEW RELATED DOCUMENTS ==
  action(:show_related_documents) { |b| b.frm.button(alt: 'open View Related Documents').click }
  alias_method :show_view_related_documents, :show_related_documents
  action(:show_purchase_order) { |b| b.frm.div(id: 'tab-ViewRelatedDocuments-div').button(alt: 'show').click }
  action(:close_related_documents) { |b| b.frm.button(alt: 'close View Related Documents').click }

  value(:purchase_order_number) { |b| b.div(id: 'tab-ViewRelatedDocuments-div').a(target: '_BLANK').text }
  value(:po_unapprove) { |b| b.div(id: 'tab-ViewRelatedDocuments-div').div.h3s[1].font.text }
  element(:view_related_doc) { |b| b.div(id: 'tab-ViewRelatedDocuments-div').div.h3s }
  action(:purchase_order_number_link) { |b| b.div(id: 'tab-ViewRelatedDocuments-div').a(target: '_BLANK').click; b.use_new_tab; b.close_parents }

  element(:purchase_order_amendment_item) {|b| b.h3(text: /Purchase Order Amendment - Doc #/).link(target: '_BLANK') }
  action(:purchase_order_amendment) {|b| b.purchase_order_amendment_item.click; b.use_new_tab; b.close_parents }
  value(:purchase_order_amendment_value) {|b| b.purchase_order_amendment_item.text }

end
