class ObjectCodePage < KFSBasePage

  element(:fiscal_year) { |b| b.frm.text_field(name: 'document.newMaintainableObject.universityFiscalYear') }
  element(:new_chart_code) { |b| b.frm.select(name: 'document.newMaintainableObject.chartOfAccountsCode') }
  element(:object_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.financialObjectCode') } #editable text field
  #value(:object_code_value) { |b| b.frm.span(id: "document.newMaintainableObject.financialObjectCode.div") } #non-editable text displayed for value
  element(:object_code_name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.financialObjectCodeName') }
  element(:object_code_short_name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.financialObjectCodeShortName') }
  element(:reports_to_object_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.reportsToFinancialObjectCode') }
  element(:object_type_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.financialObjectTypeCode') }
  element(:level_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.financialObjectLevelCode') }
  element(:object_sub_type_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.financialObjectSubTypeCode') }

  value(:fiscal_year_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.universityFiscalYear.div').text.strip }
  value(:new_chart_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.chartOfAccountsCode.div').text.strip }
  value(:object_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.financialObjectCode.div').text.strip }
  value(:object_code_name_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.financialObjectCodeName.div').text.strip }
  value(:object_code_short_name_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.financialObjectCodeShortName.div').text.strip }
  value(:reports_to_object_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.reportsToFinancialObjectCode.div').text.strip }
  value(:object_type_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.financialObjectTypeCode.div').text.strip }
  value(:level_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.financialObjectLevelCode.div').text.strip }
  value(:object_sub_type_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.financialObjectSubTypeCode.div').text.strip }

  value(:object_code_new) { |b| b.object_code.exists? ? b.object_code.value : b.object_code_readonly }
  value(:fiscal_year_new) { |b| b.fiscal_year.exists? ? b.fiscal_year.value : b.fiscal_year_readonly }
  value(:new_chart_code_new) { |b| b.new_chart_code.exists? ? b.new_chart_code.value : b.new_chart_code_readonly }
  value(:object_code_name_new) { |b| b.object_code_name.exists? ? b.object_code_name.value : b.object_code_name_readonly }
  value(:object_code_short_name_new) { |b| b.object_code_short_name.exists? ? b.object_code_short_name.value : b.object_code_short_name_readonly }
  value(:reports_to_object_code_new) { |b| b.reports_to_object_code.exists? ? b.reports_to_object_code.value : b.reports_to_object_code_readonly }
  value(:object_type_code_new) { |b| b.object_type_code.exists? ? b.object_type_code.value : b.object_type_code_readonly }
  value(:level_code_new) { |b| b.level_code.exists? ? b.level_code.value : b.level_code_readonly }
  value(:object_sub_type_code_new) { |b| b.object_sub_type_code.exists? ? b.object_sub_type_code.value : b.object_sub_type_code_readonly }

  value(:fiscal_year_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.universityFiscalYear.div').text.strip }
  value(:new_chart_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.chartOfAccountsCode.div').text.strip }
  value(:object_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.financialObjectCode.div').text.strip }
  value(:object_code_name_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.financialObjectCodeName.div').text.strip }
  value(:object_code_short_name_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.financialObjectCodeShortName.div').text.strip }
  value(:reports_to_object_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.reportsToFinancialObjectCode.div').text.strip }
  value(:object_type_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.financialObjectTypeCode.div').text.strip }
  value(:level_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.financialObjectLevelCode.div').text.strip }
  value(:object_sub_type_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.financialObjectSubTypeCode.div').text.strip }

  #CU item
  element(:suny_object_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.extension.sunyObjectCode') }
  element(:financial_object_code_description) { |b| b.frm.textarea(name: 'document.newMaintainableObject.extension.financialObjectCodeDescr') }
  element(:cg_reporting_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.extension.cgReportingCode') }
  element(:historical_financial_object_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.historicalFinancialObjectCode') }
  element(:active_indicator) { |b| b.frm.checkbox(name: 'document.newMaintainableObject.active') }
  element(:budget_aggregation_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.financialBudgetAggregationCd') }
  element(:mandatory_transfer) { |b| b.frm.select(name: 'document.newMaintainableObject.finObjMandatoryTrnfrelimCd') }
  element(:federal_funded_code) { |b| b.frm.select(name: 'document.newMaintainableObject.financialFederalFundedCode') }
  element(:next_year_object_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.nextYearFinancialObjectCode') }

  value(:suny_object_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.sunyObjectCode.div').text.strip }
  value(:financial_object_code_description_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.extension.financialObjectCodeDescr.div').text.strip }
  value(:cg_reporting_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.extension.cgReportingCode.div').text.strip }
  value(:historical_financial_object_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.historicalFinancialObjectCode.div').text.strip }
  value(:active_indicator_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.active.div').text.strip }
  value(:budget_aggregation_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.financialBudgetAggregationCd.div').text.strip }
  value(:mandatory_transfer_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.finObjMandatoryTrnfrelimCd.div').text.strip }
  value(:next_year_object_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.nextYearFinancialObjectCode.div').text.strip }

  value(:suny_object_code_new) { |b| b.suny_object_code.exists? ? b.suny_object_code.value : b.suny_object_code_readonly }
  value(:financial_object_code_description_new) { |b| b.financial_object_code_description.exists? ? b.financial_object_code_description.value : b.financial_object_code_description_readonly }
  value(:cg_reporting_code_new) { |b| b.cg_reporting_code.exists? ? b.cg_reporting_code.value : b.cg_reporting_code_readonly }
  value(:historical_financial_object_code_new) { |b| b.historical_financial_object_code.exists? ? b.historical_financial_object_code.value : b.historical_financial_object_code_readonly }
  value(:active_indicator_new) { |b| b.active_indicator.exists? ? b.active_indicator.value : b.active_indicator_readonly }
  value(:budget_aggregation_code_new) { |b| b.budget_aggregation_code.exists? ? b.budget_aggregation_code.value : b.budget_aggregation_code_readonly }
  value(:mandatory_transfer_new) { |b| b.mandatory_transfer.exists? ? b.mandatory_transfer.selected_options.first.text : b.mandatory_transfer_readonly }
  value(:federal_funded_code_new) { |b| b.federal_funded_code.exists? ? b.federal_funded_code.selected_options.first.text : b.federal_funded_code_readonly }
  value(:next_year_object_code_new) { |b| b.next_year_object_code.exists? ? b.next_year_object_code.value : b.next_year_object_code_readonly }

  value(:suny_object_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.sunyObjectCode.div').text.strip }
  value(:financial_object_code_description_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.financialObjectCodeDescr.div').text.strip }
  value(:cg_reporting_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.cgReportingCode.div').text.strip }
  value(:historical_financial_object_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.historicalFinancialObjectCode.div').text.strip }
  value(:active_indicator_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.active.div').text.strip }
  value(:budget_aggregation_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.financialBudgetAggregationCd.div').text.strip }
  value(:mandatory_transfer_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.finObjMandatoryTrnfrelimCd.div').text.strip }
  value(:next_year_object_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.nextYearFinancialObjectCode.div').text.strip }

  #DOCUMENT
  action(:search_reports_to_object_code) { |b| b.frm.button(alt: 'Search Reports To Object Code').click }


end