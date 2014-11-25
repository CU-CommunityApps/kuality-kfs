class OrganizationPage < KFSBasePage

  element(:chart_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.chartOfAccountsCode') }
  element(:organization_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.organizationCode') }
  element(:name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.organizationName') }
  element(:manager_principal_name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.organizationManagerUniversal.principalName') }
  element(:resp_center_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.responsibilityCenterCode') }
  element(:physcal_campus_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.organizationPhysicalCampusCode') }
  element(:type_code) { |b| b.frm.select(name: 'document.newMaintainableObject.organizationTypeCode') }
  element(:default_account_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.organizationDefaultAccountNumber') }
  element(:address_line_1) { |b| b.frm.text_field(name: 'document.newMaintainableObject.organizationLine1Address') }
  element(:address_line_2) { |b| b.frm.text_field(name: 'document.newMaintainableObject.organizationLine2Address') }
  element(:postal_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.organizationZipCode') }
  element(:country_code) { |b| b.frm.select(name: 'document.newMaintainableObject.organizationCountryCode') }
  element(:begin_date) { |b| b.frm.text_field(name: 'document.newMaintainableObject.organizationBeginDate') }
  element(:end_date) { |b| b.frm.text_field(name: 'document.newMaintainableObject.organizationEndDate') }
  element(:reports_to_chart_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.reportsToChartOfAccountsCode') }
  element(:reports_to_org_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.reportsToOrganizationCode') }
  element(:active) { |b| b.frm.checkbox(name: 'document.newMaintainableObject.active') }
  element(:plant_chart) { |b| b.frm.select(name: 'document.newMaintainableObject.organizationPlantChartCode') }
  element(:plant_account_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.organizationPlantAccountNumber') }
  element(:campus_plant_chart_code) { |b| b.frm.select(name: 'document.newMaintainableObject.campusPlantChartCode') }
  element(:campus_plant_account_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.campusPlantAccountNumber') }

  value(:chart_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.chartOfAccountsCode.div').text.strip }
  value(:organization_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.organizationCode.div').text.strip }
  value(:name_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.organizationName.div').text.strip }
  value(:manager_principal_name_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.organizationManagerUniversal.principalName.div').text.strip }
  value(:resp_center_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.responsibilityCenterCode.div').text.strip }
  value(:physcal_campus_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.organizationPhysicalCampusCode.div').text.strip }
  value(:default_account_number_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.organizationDefaultAccountNumber.div').text.strip }
  value(:type_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.organizationTypeCode.div').text.strip }
  value(:address_line_1_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.organizationLine1Address.div').text.strip }
  value(:address_line_2_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.organizationLine2Address.div').text.strip }
  value(:postal_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.organizationZipCode.div').text.strip }
  value(:country_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.organizationCountryCode.div').text.strip }
  value(:begin_date_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.organizationBeginDate.div').text.strip }
  value(:end_date_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.organizationEndDate.div').text.strip }
  value(:reports_to_chart_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.reportsToChartOfAccountsCode.div').text.strip }
  value(:reports_to_org_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.reportsToOrganizationCode.div').text.strip }
  value(:active_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.active.div').text.strip }
  value(:plant_chart_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.organizationPlantChartCode.div').text.strip }
  value(:plant_account_number_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.organizationPlantAccountNumber.div').text.strip }
  value(:campus_plant_chart_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.campusPlantChartCode.div').text.strip }
  value(:campus_plant_account_number_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.campusPlantAccountNumber.div').text.strip }

  value(:chart_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.chartOfAccountsCode.div').text.strip }
  value(:organization_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.organizationCode.div').text.strip }
  value(:name_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.organizationName.div').text.strip }
  value(:manager_principal_name_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.organizationManagerUniversal.principalName.div').text.strip }
  value(:resp_center_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.responsibilityCenterCode.div').text.strip }
  value(:physcal_campus_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.organizationPhysicalCampusCode.div').text.strip }
  value(:default_account_number_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.organizationDefaultAccountNumber.div').text.strip }
  value(:type_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.organizationTypeCode.div').text.strip }
  value(:address_line_1_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.organizationLine1Address.div').text.strip }
  value(:address_line_2_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.organizationLine2Address.div').text.strip }
  value(:postal_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.organizationZipCode.div').text.strip }
  value(:country_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.organizationCountryCode.div').text.strip }
  value(:begin_date_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.organizationBeginDate.div').text.strip }
  value(:end_date_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.organizationEndDate.div').text.strip }
  value(:reports_to_chart_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.reportsToChartOfAccountsCode.div').text.strip }
  value(:reports_to_org_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.reportsToOrganizationCode.div').text.strip }
  value(:active_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.active.div').text.strip }
  value(:plant_chart_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.organizationPlantChartCode.div').text.strip }
  value(:plant_account_number_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.organizationPlantAccountNumber.div').text.strip }
  value(:campus_plant_chart_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.campusPlantChartCode.div').text.strip }
  value(:campus_plant_account_number_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.campusPlantAccountNumber.div').text.strip }

  value(:chart_code_new) { |b| b.chart_code.exists? ? b.chart_code.value : b.chart_code_readonly }
  value(:organization_code_new) { |b| b.organization_code.exists? ? b.organization_code.value : b.organization_code_readonly }
  value(:name_new) { |b| b.name.exists? ? b.name.value : b.name_readonly }
  value(:manager_principal_name_new) { |b| b.manager_principal_name.exists? ? b.manager_principal_name.value : b.manager_principal_name_readonly }
  value(:resp_center_code_new) { |b| b.resp_center_code.exists? ? b.resp_center_code.value : b.resp_center_code_readonly }
  value(:physcal_campus_code_new) { |b| b.physcal_campus_code.exists? ? b.physcal_campus_code.value : b.physcal_campus_code_readonly }
  value(:type_code_new) { |b| b.type_code.exists? ? b.type_code.selected_options.first.text : b.type_code_readonly }
  value(:default_account_number_new) { |b| b.default_account_number.exists? ? b.default_account_number.value : b.default_account_number_readonly }
  value(:address_line_1_new) { |b| b.address_line_1.exists? ? b.address_line_1.value : b.address_line_1_readonly }
  value(:address_line_2_new) { |b| b.address_line_2.exists? ? b.address_line_2.value : b.address_line_2_readonly }
  value(:postal_code_new) { |b| b.postal_code.exists? ? b.postal_code.value : b.postal_code_readonly }
  value(:country_code_new) { |b| b.country_code.exists? ? b.country_code.value : b.country_code_readonly }
  value(:begin_date_new) { |b| b.begin_date.exists? ? b.begin_date.value : b.begin_date_readonly }
  value(:end_date_new) { |b| b.end_date.exists? ? b.end_date.value : b.end_date_readonly }
  value(:reports_to_chart_code_new) { |b| b.reports_to_chart_code.exists? ? b.reports_to_chart_code.value : b.reports_to_chart_code_readonly }
  value(:reports_to_org_code_new) { |b| b.reports_to_org_code.exists? ? b.reports_to_org_code.value : b.reports_to_org_code_readonly }
  value(:active_new) { |b| b.active.exists? ? b.active.value : b.active_readonly }
  value(:plant_chart_new) { |b| b.plant_chart.exists? ? b.plant_chart.selected_options.first.text : b.plant_chart_readonly }
  value(:plant_account_number_new) { |b| b.plant_account_number.exists? ? b.plant_account_number.value : b.plant_account_number_readonly }
  value(:campus_plant_chart_code_new) { |b| b.campus_plant_chart_code.exists? ? b.campus_plant_chart_code.selected_options.first.text : b.campus_plant_chart_code_readonly }
  value(:campus_plant_account_number_new) { |b| b.campus_plant_account_number.exists? ? b.campus_plant_account_number.value : b.campus_plant_account_number_readonly }


end