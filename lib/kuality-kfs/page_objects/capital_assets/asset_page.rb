class AssetPage < KFSBasePage

  # ASSET DETAIL INFORMATION  - Editing
  element(:organization_owner_chart_of_accounts_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.organizationOwnerChartOfAccountsCode') }
  element(:organization_owner_account_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.organizationOwnerAccountNumber') }
  element(:owner) { |b| b.frm.text_field(name: 'document.newMaintainableObject.agencyNumber') }
  element(:asset_status_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.inventoryStatusCode') }

  element(:asset_condition) { |b| b.frm.select(name: 'document.newMaintainableObject.conditionCode') }

  element(:asset_description) { |b| b.frm.text_field(name: 'document.newMaintainableObject.capitalAssetDescription') }
  element(:asset_type_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.capitalAssetTypeCode') }
  element(:vendor_name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.vendorName') }
  element(:manufacturer) { |b| b.frm.text_field(name: 'document.newMaintainableObject.manufacturerName') }
  element(:model_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.manufacturerModelNumber') }
  element(:serial_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.serialNumber') }
  element(:tag_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.campusTagNumber') }
  element(:old_tag_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.oldTagNumber') }
  element(:government_tag_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.governmentTagNumber') }
  element(:national_stock_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.nationalStockNumber') }

  element(:financial_object_sub_type_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.financialObjectSubTypeCode') }
  element(:in_service_date) { |b| b.frm.text_field(name: 'document.newMaintainableObject.capitalAssetInServiceDate') }

  # OLD
  value(:organization_owner_chart_of_accounts_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.organizationOwnerChartOfAccountsCode.div').text.strip }
  value(:organization_owner_account_number_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.organizationOwnerAccountNumber.div').text.strip }
  value(:owner_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.agencyNumber.div').text.strip }
  value(:asset_status_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.inventoryStatusCode.div').text.strip }
  value(:asset_condition_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.conditionCode.div').text.strip }
  value(:asset_description_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.capitalAssetDescription.div').text.strip }
  value(:asset_type_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.capitalAssetTypeCode.div').text.strip }
  value(:vendor_name_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.vendorName.div').text.strip }
  value(:manufacturer_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.manufacturerName.div').text.strip }
  value(:model_number_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.manufacturerModelNumber.div').text.strip }
  value(:serial_number_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.serialNumber.div').text.strip }
  value(:tag_number_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.campusTagNumber.div').text.strip }
  value(:old_tag_number_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.oldTagNumber.div').text.strip }
  value(:government_tag_number_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.governmentTagNumber.div').text.strip }
  value(:national_stock_number_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.nationalStockNumber.div').text.strip }
  value(:financial_object_sub_type_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.financialObjectSubTypeCode.div').text.strip }
  value(:in_service_date_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.capitalAssetInServiceDate.div').text.strip }

  # Readonly
  value(:organization_owner_chart_of_accounts_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.organizationOwnerChartOfAccountsCode.div').text.strip }
  value(:organization_owner_account_number_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.organizationOwnerAccountNumber.div').text.strip }
  value(:owner_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.agencyNumber.div').text.strip }
  value(:asset_status_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.inventoryStatusCode.div').text.strip }
  value(:asset_condition_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.conditionCode.div').text.strip }
  value(:asset_description_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.capitalAssetDescription.div').text.strip }
  value(:asset_type_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.capitalAssetTypeCode.div').text.strip }
  value(:vendor_name_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.vendorName.div').text.strip }
  value(:manufacturer_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.manufacturerName.div').text.strip }
  value(:model_number_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.manufacturerModelNumber.div').text.strip }
  value(:serial_number_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.serialNumber.div').text.strip }
  value(:tag_number_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.campusTagNumber.div').text.strip }
  value(:old_tag_number_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.oldTagNumber.div').text.strip }
  value(:government_tag_number_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.governmentTagNumber.div').text.strip }
  value(:national_stock_number_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.nationalStockNumber.div').text.strip }
  value(:financial_object_sub_type_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.financialObjectSubTypeCode.div').text.strip }
  value(:in_service_date_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.capitalAssetInServiceDate.div').text.strip }

  # new
  value(:organization_owner_chart_of_accounts_code_new) { |b| b.organization_owner_chart_of_accounts_code.exists? ? b.organization_owner_chart_of_accounts_code.value : b.organization_owner_chart_of_accounts_code_readonly }
  value(:organization_owner_account_number_new) { |b| b.organization_owner_account_number.exists? ? b.organization_owner_account_number.value : b.organization_owner_account_number_readonly }
  value(:owner_new) { |b| b.owner.exists? ? b.owner.value : b.owner_readonly }
  value(:asset_status_code_new) { |b| b.asset_status_code.exists? ? b.asset_status_code.value : b.asset_status_code_readonly }
  value(:asset_condition_new) { |b| b.asset_condition.exists? ? b.asset_condition.selected_options.first.text : b.asset_condition_readonly }
  value(:asset_description_new) { |b| b.asset_description.exists? ? b.asset_description.value : b.asset_description_readonly }
  value(:asset_type_code_new) { |b| b.asset_type_code.exists? ? b.asset_type_code.value : b.asset_type_code_readonly }
  value(:vendor_name_new) { |b| b.vendor_name.exists? ? b.vendor_name.value : b.vendor_name_readonly }
  value(:manufacturer_new) { |b| b.manufacturer.exists? ? b.manufacturer.value : b.manufacturer_readonly }
  value(:model_number_new) { |b| b.model_number.exists? ? b.model_number.value : b.model_number_readonly }
  value(:serial_number_new) { |b| b.serial_number.exists? ? b.serial_number.value : b.serial_number_readonly }
  value(:tag_number_new) { |b| b.tag_number.exists? ? b.tag_number.value : b.tag_number_readonly }
  value(:old_tag_number_new) { |b| b.old_tag_number.exists? ? b.old_tag_number.value : b.old_tag_number_readonly }
  value(:government_tag_number_new) { |b| b.government_tag_number.exists? ? b.government_tag_number.value : b.government_tag_number_readonly }
  value(:national_stock_number_new) { |b| b.national_stock_number.exists? ? b.national_stock_number.value : b.national_stock_number_readonly }
  value(:financial_object_sub_type_code_new) { |b| b.financial_object_sub_type_code.exists? ? b.financial_object_sub_type_code.value : b.financial_object_sub_type_code_readonly }
  value(:in_service_date_new) { |b| b.in_service_date.exists? ? b.in_service_date.value : b.in_service_date_readonly }

  #ASSET LOCATION - Editing
  element(:on_campus_campus) { |b| b.frm.text_field(name: 'document.newMaintainableObject.campusCode') }
  element(:on_campus_building_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.buildingCode') }
  element(:on_campus_building_room_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.buildingRoomNumber') }
  element(:on_campus_building_sub_room_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.buildingSubRoomNumber') }

  element(:off_campus_name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.offCampusLocation.assetLocationContactName') }
  element(:off_campus_address) { |b| b.frm.text_field(name: 'document.newMaintainableObject.offCampusLocation.assetLocationStreetAddress') }
  element(:off_campus_city) { |b| b.frm.text_field(name: 'document.newMaintainableObject.offCampusLocation.assetLocationCityName') }
  element(:off_campus_state) { |b| b.frm.text_field(name: 'document.newMaintainableObject.offCampusLocation.assetLocationStateCode') }
  element(:off_campus_postal_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.offCampusLocation.assetLocationZipCode') }

  element(:off_campus_country) { |b| b.frm.select(name: 'document.newMaintainableObject.offCampusLocation.assetLocationCountryCode') }

  # OLD
  value(:on_campus_campus_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.campusCode.div').text.strip }
  value(:on_campus_building_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.buildingCode.div').text.strip }
  value(:on_campus_building_room_number_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.buildingRoomNumber.div').text.strip }
  value(:on_campus_building_sub_room_number_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.buildingSubRoomNumber.div').text.strip }
  value(:off_campus_name_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.offCampusLocation.assetLocationContactName.div').text.strip }
  value(:off_campus_address_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.offCampusLocation.assetLocationStreetAddress.div').text.strip }
  value(:off_campus_city_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.offCampusLocation.assetLocationCityName.div').text.strip }
  value(:off_campus_state_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.offCampusLocation.assetLocationStateCode.div').text.strip }
  value(:off_campus_postal_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.offCampusLocation.assetLocationZipCode.div').text.strip }
  value(:off_campus_country_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.offCampusLocation.assetLocationCountryCode.div').text.strip }

   # Readonly
  value(:on_campus_campus_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.campusCode.div').text.strip }
  value(:on_campus_building_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.buildingCode.div').text.strip }
  value(:on_campus_building_room_number_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.buildingRoomNumber.div').text.strip }
  value(:on_campus_building_sub_room_number_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.buildingSubRoomNumber.div').text.strip }
  value(:off_campus_name_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.offCampusLocation.assetLocationContactName.div').text.strip }
  value(:off_campus_address_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.offCampusLocation.assetLocationStreetAddress.div').text.strip }
  value(:off_campus_city_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.offCampusLocation.assetLocationCityName.div').text.strip }
  value(:off_campus_state_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.offCampusLocation.assetLocationStateCode.div').text.strip }
  value(:off_campus_postal_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.offCampusLocation.assetLocationZipCode.div').text.strip }
  value(:off_campus_country_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.offCampusLocation.assetLocationCountryCode.div').text.strip }

  # new
  value(:on_campus_campus_new) { |b| b.on_campus_campus.exists? ? b.on_campus_campus.value : b.on_campus_campus_readonly }
  value(:on_campus_building_code_new) { |b| b.on_campus_building_code.exists? ? b.on_campus_building_code.value : b.on_campus_building_code_readonly }
  value(:on_campus_building_room_number_new) { |b| b.on_campus_building_room_number.exists? ? b.on_campus_building_room_number.value : b.on_campus_building_room_number_readonly }
  value(:on_campus_building_sub_room_number_new) { |b| b.on_campus_building_sub_room_number.exists? ? b.on_campus_building_sub_room_number.value : b.on_campus_building_sub_room_number_readonly }
  value(:off_campus_name_new) { |b| b.off_campus_name.exists? ? b.off_campus_name.value : b.off_campus_name_readonly }
  value(:off_campus_address_new) { |b| b.off_campus_address.exists? ? b.off_campus_address.value : b.off_campus_address_readonly }
  value(:off_campus_city_new) { |b| b.off_campus_city.exists? ? b.off_campus_city.value : b.off_campus_city_readonly }
  value(:off_campus_state_new) { |b| b.off_campus_state.exists? ? b.off_campus_state.value : b.off_campus_state_readonly }
  value(:off_campus_postal_code_new) { |b| b.off_campus_postal_code.exists? ? b.off_campus_postal_code.value : b.off_campus_postal_code_readonly }
  value(:off_campus_country_new) { |b| b.off_campus_country.exists? ? b.off_campus_country.selected_options.first.text : b.off_campus_country_readonly }

end