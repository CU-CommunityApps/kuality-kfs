class PreAssetTaggingPage < KFSBasePage

  #Edit Pre-Asset Tagging
  element(:purchase_order_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.purchaseOrderNumber') }
  element(:item_line_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.itemLineNumber') }
  element(:quantity_ordered) { |b| b.frm.text_field(name: 'document.newMaintainableObject.quantityInvoiced') }

  element(:asset_type_code) { |b| b.frm.select(name: 'document.newMaintainableObject.capitalAssetTypeCode') }

  element(:manufacturer_name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.manufacturerName') }
  element(:manufacturer_model_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.manufacturerModelNumber') }
  element(:vendor_name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.vendorName') }

  element(:organization_owner_chart_of_accounts_code) { |b| b.frm.select(name: 'document.newMaintainableObject.chartOfAccountsCode') }

  element(:organization_owner_organization_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.organizationCode') }
  element(:organization_inventory_name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.organizationInventoryName') }
  element(:asset_representative_principal_name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.personUniversal.principalName') }
  element(:organization_text) { |b| b.frm.text_field(name: 'document.newMaintainableObject.organizationText') }
  element(:purchase_order_line_item_description) { |b| b.frm.textarea(name: 'document.newMaintainableObject.assetTopsDescription') }
  element(:pretag_create_date) { |b| b.frm.text_field(name: 'document.newMaintainableObject.pretagCreateDate') }

  element(:pretag_active_indicator) { |b| b.frm.div(id: 'tab-EditPreAssetTagging-div').checkbox(name: 'document.newMaintainableObject.active') }

  # OLD
  value(:purchase_order_number_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.purchaseOrderNumber.div').text.strip }
  value(:item_line_number_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.itemLineNumber.div').text.strip }
  value(:quantity_ordered_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.quantityInvoiced.div').text.strip }
  value(:asset_type_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.capitalAssetTypeCode.div').text.strip }
  value(:manufacturer_name_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.manufacturerName.div').text.strip }
  value(:manufacturer_model_number_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.manufacturerModelNumber.div').text.strip }
  value(:vendor_name_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.vendorName.div').text.strip }
  value(:organization_owner_chart_of_accounts_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.chartOfAccountsCode.div').text.strip }
  value(:organization_owner_organization_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.organizationCode.div').text.strip }
  value(:organization_inventory_name_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.organizationInventoryName.div').text.strip }
  value(:asset_representative_principal_name_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.personUniversal.principalName.div').text.strip }
  value(:organization_text_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.organizationText.div').text.strip }
  value(:purchase_order_line_item_description_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.assetTopsDescription.div').text.strip }
  value(:pretag_create_date_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.pretagCreateDate.div').text.strip }
  value(:pretag_active_indicator_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.active.div').text.strip }

  # readonly

  value(:purchase_order_number_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.purchaseOrderNumber.div').text.strip }
  value(:item_line_number_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.itemLineNumber.div').text.strip }
  value(:quantity_ordered_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.quantityInvoiced.div').text.strip }
  value(:asset_type_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.capitalAssetTypeCode.div').text.strip }
  value(:manufacturer_name_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.manufacturerName.div').text.strip }
  value(:manufacturer_model_number_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.manufacturerModelNumber.div').text.strip }
  value(:vendor_name_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.vendorName.div').text.strip }
  value(:organization_owner_chart_of_accounts_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.chartOfAccountsCode.div').text.strip }
  value(:organization_owner_organization_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.organizationCode.div').text.strip }
  value(:organization_inventory_name_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.organizationInventoryName.div').text.strip }
  value(:asset_representative_principal_name_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.personUniversal.principalName.div').text.strip }
  value(:organization_text_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.organizationText.div').text.strip }
  value(:purchase_order_line_item_description_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.assetTopsDescription.div').text.strip }
  value(:pretag_create_date_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.pretagCreateDate.div').text.strip }
  value(:pretag_active_indicator_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.active.div').text.strip }

  value(:purchase_order_number_new) { |b| b.purchase_order_number.exists? ? b.purchase_order_number.value : b.purchase_order_number_readonly }
  value(:item_line_number_new) { |b| b.item_line_number.exists? ? b.item_line_number.value : b.item_line_number_readonly }
  value(:quantity_ordered_new) { |b| b.quantity_ordered.exists? ? b.quantity_ordered.value : b.quantity_ordered_readonly }
  value(:asset_type_code_new) { |b| b.asset_type_code.exists? ? b.asset_type_code.value : b.asset_type_code_readonly }
  value(:manufacturer_name_new) { |b| b.manufacturer_name.exists? ? b.manufacturer_name.value : b.manufacturer_name_readonly }
  value(:manufacturer_model_number_new) { |b| b.manufacturer_model_number.exists? ? b.manufacturer_model_number.value : b.manufacturer_model_number_readonly }
  value(:vendor_name_new) { |b| b.vendor_name.exists? ? b.vendor_name.value : b.vendor_name_readonly }
  value(:organization_owner_chart_of_accounts_code_new) { |b| b.organization_owner_chart_of_accounts_code.exists? ? b.organization_owner_chart_of_accounts_code.value : b.organization_owner_chart_of_accounts_code_readonly }
  value(:organization_owner_organization_code_new) { |b| b.organization_owner_organization_code.exists? ? b.organization_owner_organization_code.value : b.organization_owner_organization_code_readonly }
  value(:organization_inventory_name_new) { |b| b.organization_inventory_name.exists? ? b.organization_inventory_name.value : b.organization_inventory_name_readonly }
  value(:asset_representative_principal_name_new) { |b| b.asset_representative_principal_name.exists? ? b.asset_representative_principal_name.value : b.asset_representative_principal_name_readonly }
  value(:organization_text_new) { |b| b.organization_text.exists? ? b.organization_text.value : b.organization_text_readonly }
  value(:purchase_order_line_item_description_new) { |b| b.purchase_order_line_item_description.exists? ? b.purchase_order_line_item_description.value : b.purchase_order_line_item_description_readonly }
  value(:pretag_create_date_new) { |b| b.pretag_create_date.exists? ? b.pretag_create_date.value : b.pretag_create_date_readonly }
  value(:pretag_active_indicator_new) { |b| b.pretag_active_indicator.exists? ? b.pretag_active_indicator.value : b.pretag_active_indicator_readonly }

  #NEW DETAIL
  element(:tag_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.add.pretagDetails.campusTagNumber') }
  element(:serial_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.add.pretagDetails.serialNumber') }
  element(:organization_tag_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.add.pretagDetails.organizationTagNumber') }
  element(:government_tag) { |b| b.frm.text_field(name: 'document.newMaintainableObject.add.pretagDetails.governmentTagNumber') }
  element(:national_stock_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.add.pretagDetails.nationalStockNumber') }

  element(:campus_code) { |b| b.frm.select(name: 'document.newMaintainableObject.add.pretagDetails.campusCode') }

  element(:building_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.add.pretagDetails.buildingCode') }
  element(:building_room_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.add.pretagDetails.buildingRoomNumber') }
  element(:building_sub_room_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.add.pretagDetails.buildingSubRoomNumber') }
  element(:pretag_tag_create_date) { |b| b.frm.text_field(name: 'document.newMaintainableObject.add.pretagDetails.pretagTagCreateDate') }

  element(:new_pretag_active_indicator) { |b| b.frm.div(id: 'tab-EditListofPreAssetTaggingDetails-div').checkbox(name: 'document.newMaintainableObject.add.pretagDetails.active') }

  action(:add_new_detail) { |b| b.frm.div(id: 'tab-EditListofPreAssetTaggingDetails-div').button(id: /^methodToCall\.addLine\.pretagDetails/).click }

end