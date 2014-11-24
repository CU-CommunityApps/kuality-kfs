class AssetFabricationMaintenanceDocumentPage < KFSBasePage

  #TODO : this page and asset page shared several common elements.  should consider to create a base page to be extended by both
  #ASSET DETAIL INFORMATION
  element(:organization_owner_chart_of_accounts_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.organizationOwnerChartOfAccountsCode') }
  element(:organization_owner_account_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.organizationOwnerAccountNumber') }
  element(:owner) { |b| b.frm.text_field(name: 'document.newMaintainableObject.agencyNumber') }
  element(:asset_condition) { |b| b.frm.select(name: 'document.newMaintainableObject.conditionCode') }
  element(:asset_description) { |b| b.frm.textarea(name: 'document.newMaintainableObject.capitalAssetDescription') }
  element(:asset_type_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.capitalAssetTypeCode') }

  value(:organization_owner_chart_of_accounts_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.organizationOwnerChartOfAccountsCode.div').text.strip }
  value(:organization_owner_account_number_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.organizationOwnerAccountNumber.div').text.strip }
  value(:owner_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.agencyNumber.div').text.strip }
  value(:asset_condition_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.conditionCode.div').text.strip }
  value(:asset_description_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.capitalAssetDescription.div').text.strip }
  value(:asset_type_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.capitalAssetTypeCode.div').text.strip }

  value(:organization_owner_chart_of_accounts_code_new) { |b| b.organization_owner_chart_of_accounts_code.exists? ? b.organization_owner_chart_of_accounts_code.value : b.organization_owner_chart_of_accounts_code_readonly }
  value(:organization_owner_account_number_new) { |b| b.organization_owner_account_number.exists? ? b.organization_owner_account_number.value : b.organization_owner_account_number_readonly }
  value(:owner_new) { |b| b.owner.exists? ? b.owner.value : b.owner_readonly }
  value(:asset_condition_new) { |b| b.asset_condition.exists? ? b.asset_condition.selected_options.first.text : b.asset_condition_readonly }
  value(:asset_description_new) { |b| b.asset_description.exists? ? b.asset_description.value : b.asset_description_readonly }
  value(:asset_type_code_new) { |b| b.asset_type_code.exists? ? b.asset_type_code.value : b.asset_type_code_readonly }

  #NEW - ON CAMPUS
  element(:on_campus_campus) { |b| b.frm.text_field(name: 'document.newMaintainableObject.campusCode') }
  element(:on_campus_building_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.buildingCode') }
  element(:on_campus_building_room_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.buildingRoomNumber') }
  element(:on_campus_building_sub_room_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.buildingSubRoomNumber') }

  value(:on_campus_campus_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.campusCode.div').text.strip }
  value(:on_campus_building_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.buildingCode.div').text.strip }
  value(:on_campus_building_room_number_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.buildingRoomNumber.div').text.strip }
  value(:on_campus_building_sub_room_number_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.buildingSubRoomNumber.div').text.strip }

  value(:on_campus_campus_new) { |b| b.on_campus_campus.exists? ? b.on_campus_campus.value : b.on_campus_campus_readonly }
  value(:on_campus_building_code_new) { |b| b.on_campus_building_code.exists? ? b.on_campus_building_code.value : b.on_campus_building_code_readonly }
  value(:on_campus_building_room_number_new) { |b| b.on_campus_building_room_number.exists? ? b.on_campus_building_room_number.value : b.on_campus_building_room_number_readonly }
  value(:on_campus_building_sub_room_number_new) { |b| b.on_campus_building_sub_room_number.exists? ? b.on_campus_building_sub_room_number.value : b.on_campus_building_sub_room_number_readonly }

  #NEW - OFF CAMPUS
  element(:off_campus_name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.offCampusLocation.assetLocationContactName') }
  element(:off_campus_address) { |b| b.frm.text_field(name: 'document.newMaintainableObject.offCampusLocation.assetLocationStreetAddress') }
  element(:off_campus_city) { |b| b.frm.text_field(name: 'document.newMaintainableObject.offCampusLocation.assetLocationCityName') }
  element(:off_campus_state) { |b| b.frm.text_field(name: 'document.newMaintainableObject.offCampusLocation.assetLocationStateCode') }
  element(:off_campus_postal_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.offCampusLocation.assetLocationZipCode') }
  element(:off_campus_country) { |b| b.frm.select(name: 'document.newMaintainableObject.offCampusLocation.assetLocationCountryCode') }

  value(:off_campus_name_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.offCampusLocation.assetLocationContactName.div').text.strip }
  value(:off_campus_address_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.offCampusLocation.assetLocationStreetAddress.div').text.strip }
  value(:off_campus_city_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.offCampusLocation.assetLocationCityName.div').text.strip }
  value(:off_campus_state_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.offCampusLocation.assetLocationStateCode.div').text.strip }
  value(:off_campus_postal_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.offCampusLocation.assetLocationZipCode.div').text.strip }
  value(:off_campus_country_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.offCampusLocation.assetLocationCountryCode.div').text.strip }

  value(:off_campus_name_new) { |b| b.off_campus_name.exists? ? b.off_campus_name.value : b.off_campus_name_readonly }
  value(:off_campus_address_new) { |b| b.off_campus_address.exists? ? b.off_campus_address.value : b.off_campus_address_readonly }
  value(:off_campus_city_new) { |b| b.off_campus_city.exists? ? b.off_campus_city.value : b.off_campus_city_readonly }
  value(:off_campus_state_new) { |b| b.off_campus_state.exists? ? b.off_campus_state.value : b.off_campus_state_readonly }
  value(:off_campus_postal_code_new) { |b| b.off_campus_postal_code.exists? ? b.off_campus_postal_code.value : b.off_campus_postal_code_readonly }
  value(:off_campus_country_new) { |b| b.off_campus_country.exists? ? b.off_campus_country.selected_options.first.text : b.off_campus_country_readonly }

  #ORGANIZATION INFORMATION - NEW
  element(:organization_inventory_name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.organizationInventoryName') }
  element(:asset_representative_principal_name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.assetRepresentative.principalName') }
  element(:asset_representative_name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.assetRepresentative.name') }
  element(:organization_text) { |b| b.frm.text_field(name: 'document.newMaintainableObject.assetOrganization.organizationText') }
  element(:organization_asset_type_identifier) { |b| b.frm.text_field(name: 'document.newMaintainableObject.assetOrganization.organizationAssetTypeIdentifier') }

  value(:organization_inventory_name_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.organizationInventoryName.div').text.strip }
  value(:asset_representative_principal_name_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.assetRepresentative.principalName.div').text.strip }
  value(:organization_text_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.assetOrganization.organizationText.div').text.strip }
  value(:asset_representative_name_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.assetRepresentative.div').text.strip }
  value(:organization_asset_type_identifier_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.assetOrganization.organizationAssetTypeIdentifier.div').text.strip }

  value(:organization_inventory_name_new) { |b| b.organization_inventory_name.exists? ? b.organization_inventory_name.value : b.organization_inventory_name_readonly }
  value(:asset_representative_principal_name_new) { |b| b.asset_representative_principal_name.exists? ? b.asset_representative_principal_name.value : b.asset_representative_principal_name_readonly }
  value(:organization_text_new) { |b| b.organization_text.exists? ? b.organization_text.value : b.organization_text_readonly }
  value(:asset_representative_name_new) { |b| b.asset_representative_name.exists? ? b.asset_representative_name.value : b.asset_representative_name_readonly }
  value(:organization_asset_type_identifier_new) { |b| b.organization_asset_type_identifier.exists? ? b.organization_asset_type_identifier.value : b.organization_asset_type_identifier_readonly }

  #FABRICATION INFORMATION
  element(:estimated_fabrication_completion_date) { |b| b.frm.text_field(name: 'document.newMaintainableObject.estimatedFabricationCompletionDate') }
  element(:fabrication_estimated_total_amount) { |b| b.frm.text_field(name: 'document.newMaintainableObject.fabricationEstimatedTotalAmount') }
  element(:years_expected_to_retain_asset_once_fabrication_is_complete) { |b| b.frm.text_field(name: 'document.newMaintainableObject.fabricationEstimatedRetentionYears') }
  alias_method :fabrication_is_complete, :years_expected_to_retain_asset_once_fabrication_is_complete

  value(:estimated_fabrication_completion_date_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.estimatedFabricationCompletionDate.div').text.strip }
  value(:fabrication_estimated_total_amount_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.fabricationEstimatedTotalAmount.div').text.strip }
  value(:years_expected_to_retain_asset_once_fabrication_is_complete_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.fabricationEstimatedRetentionYears.div').text.strip }

  value(:estimated_fabrication_completion_date_new) { |b| b.estimated_fabrication_completion_date.exists? ? b.estimated_fabrication_completion_date.value : b.estimated_fabrication_completion_date_readonly }
  value(:fabrication_estimated_total_amount_new) { |b| b.fabrication_estimated_total_amount.exists? ? b.fabrication_estimated_total_amount.value : b.fabrication_estimated_total_amount_readonly }
  value(:years_expected_to_retain_asset_once_fabrication_is_complete_new) { |b| b.years_expected_to_retain_asset_once_fabrication_is_complete.exists? ? b.years_expected_to_retain_asset_once_fabrication_is_complete.value : b.years_expected_to_retain_asset_once_fabrication_is_complete_readonly }

end