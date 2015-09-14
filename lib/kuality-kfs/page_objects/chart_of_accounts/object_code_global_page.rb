class ObjectCodeGlobalPage < KFSBasePage

  #Global Object Code Maintenance Tab
  element(:object_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.financialObjectCode') }
  element(:object_code_name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.financialObjectCodeName') }
  element(:object_code_short_name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.financialObjectCodeShortName') }
  element(:reports_to_object_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.reportsToFinancialObjectCode') }
  element(:object_type_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.financialObjectTypeCode') }
  element(:level_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.financialObjectLevelCode') }
  element(:cg_reporting_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.cgReportingCode') }
  element(:object_sub_type_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.financialObjectSubTypeCode') }
  element(:suny_object_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.sunyObjectCode') }
  element(:financial_object_code_description) { |b| b.frm.textarea(name: 'document.newMaintainableObject.financialObjectCodeDescr') }
  element(:historical_financial_object_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.historicalFinancialObjectCode') }
  element(:active_indicator) { |b| b.frm.checkbox(name: 'document.newMaintainableObject.financialObjectActiveIndicator') }
  element(:budget_aggregation_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.financialBudgetAggregationCd') }
  element(:mandatory_transfer) { |b| b.frm.select(name: 'document.newMaintainableObject.finObjMandatoryTrnfrOrElimCd') }
  element(:federal_funded_code) { |b| b.frm.select(name: 'document.newMaintainableObject.financialFederalFundedCode') }
  element(:next_year_object_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.nextYearFinancialObjectCode') }

  action(:object_code_search) { |b| b.frm.button(title: 'Search Object Code').click }
  action(:reports_to_object_code_search) { |b| b.frm.button(title: 'Search Reports To Object Code').click }
  action(:cg_reporting_code_search) { |b| b.frm.button(title: 'Search CG Reporting Code').click }

  #Read Only
  value(:object_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.financialObjectCode.div').text.strip }
  value(:object_code_name_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.financialObjectCodeName.div').text.strip }
  value(:object_code_short_name_readonly) { |b| b.frm.span(name: 'document.newMaintainableObject.financialObjectCodeShortName.div').text.strip }
  value(:reports_to_object_code_readonly) { |b| b.frm.span(name: 'document.newMaintainableObject.reportsToFinancialObjectCode.div').text.strip }
  value(:object_type_code_readonly) { |b| b.frm.span(name: 'document.newMaintainableObject.financialObjectTypeCode.div').text.strip }
  value(:level_code_readonly) { |b| b.frm.span(name: 'document.newMaintainableObject.financialObjectLevelCode.div').text.strip }
  value(:cg_reporting_code_readonly) { |b| b.frm.span(name: 'document.newMaintainableObject.cgReportingCode.div').text.strip }
  value(:object_sub_type_code_readonly) { |b| b.frm.span(name: 'document.newMaintainableObject.financialObjectSubTypeCode.div').text.strip }
  value(:suny_object_code_readonly) { |b| b.frm.span(name: 'document.newMaintainableObject.sunyObjectCode.div').text.strip }
  value(:financial_object_code_description_readonly) { |b| b.frm.span(name: 'document.newMaintainableObject.financialObjectCodeDescr.div').text.strip }
  value(:historical_financial_object_code_readonly) { |b| b.frm.span(name: 'document.newMaintainableObject.historicalFinancialObjectCode.div').text.strip }
  value(:active_indicator_readonly) { |b| b.frm.span(name: 'document.newMaintainableObject.financialObjectActiveIndicator.div').text.strip }
  value(:budget_aggregation_code_readonly) { |b| b.frm.span(name: 'document.newMaintainableObject.financialBudgetAggregationCd.div').text.strip }
  value(:mandatory_transfer_readonly) { |b| b.frm.span(name: 'document.newMaintainableObject.finObjMandatoryTrnfrOrElimCd.div').text.strip }
  value(:federal_funded_code_readonly) { |b| b.frm.span(name: 'document.newMaintainableObject.financialFederalFundedCode.div').text.strip }
  value(:next_year_object_code_readonly) { |b| b.frm.span(name: 'document.newMaintainableObject.nextYearFinancialObjectCode.div').text.strip }

  #New
  value(:object_code_new) { |b| b.object_code.exists? ? b.object_code.value : b.object_code_readonly }
  value(:object_code_name_new) { |b| b.object_code_name.exists? ? b.object_code_name.value : b.object_code_name_readonly }
  value(:object_code_short_name_new) { |b| b.object_code_short_name.exists? ? b.object_code_short_name.value : b.object_code_short_name_readonly }
  value(:reports_to_object_code_new) { |b| b.reports_to_object_code.exists? ? b.reports_to_object_code.value : b.reports_to_object_code_readonly }
  value(:object_type_code_new) { |b| b.object_type_code.exists? ? b.object_type_code.value : b.object_type_code_readonly }
  value(:level_code_new) { |b| b.level_code.exists? ? b.level_code.value : b.level_code_readonly }
  value(:cg_reporting_code_new) { |b| b.cg_reporting_code.exists? ? b.cg_reporting_code.value : b.cg_reporting_code_readonly }
  value(:object_sub_type_code_new) { |b| b.object_sub_type_code.exists? ? b.object_sub_type_code.value : b.object_sub_type_code_readonly }
  value(:suny_object_code_new) { |b| b.suny_object_code.exists? ? b.suny_object_code.value : b.suny_object_code_readonly }
  value(:financial_object_code_description_new) { |b| b.financial_object_code_description.exists? ? b.financial_object_code_description.value : b.financial_object_code_description_readonly }
  value(:historical_financial_object_code_new) { |b| b.historical_financial_object_code.exists? ? b.historical_financial_object_code.value : b.historical_financial_object_code_readonly }
  value(:active_indicator_new) { |b| b.active_indicator.exists? ? b.active_indicator.value : b.active_indicator_readonly }
  value(:budget_aggregation_code_new) { |b| b.budget_aggregation_code.exists? ? b.budget_aggregation_code.value : b.budget_aggregation_code_readonly }
  value(:mandatory_transfer_new) { |b| b.mandatory_transfer.exists? ? b.mandatory_transfer.value : b.mandatory_transfer_readonly }
  value(:federal_funded_code_new) { |b| b.federal_funded_code.exists? ? b.federal_funded_code.value : b.federal_funded_code_readonly }
  value(:next_year_object_code_new) { |b| b.next_year_object_code.exists? ? b.next_year_object_code.value : b.next_year_object_code_readonly }

end
