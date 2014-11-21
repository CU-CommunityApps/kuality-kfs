class SubAccountPage < KFSBasePage

  #Edit Sub-Account Code
  element(:chart_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.chartOfAccountsCode') }
  element(:account_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountNumber') }
  element(:sub_account_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.subAccountNumber') }
  element(:name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.subAccountName') }
  element(:active_indicator) { |b| b.checkbox(name: 'document.newMaintainableObject.active') }
  element(:sub_account_type_code) { |b| b.frm.select(name: 'document.newMaintainableObject.a21SubAccount.subAccountTypeCode') }

  #Edit Financial Reporting Code
  element(:financial_reporting_chart_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.financialReportChartCode') }
  action(:search_financial_reporting_chart_code) { |b| b.frm.button(alt: 'Search Financial Reporting Chart Code').click }
  element(:financial_reporting_org_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.finReportOrganizationCode') }
  action(:search_financial_reporting_org_code) { |b| b.frm.button(alt: 'Search Financial Reporting Org Code').click }
  element(:financial_reporting_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.financialReportingCode') }
  action(:search_financial_reporting_code) { |b| b.frm.button(alt: 'Search Financial Reporting Code').click }

  #Edit CG Cost Sharing
  element(:cost_sharing_chart_of_accounts_code) { |b| b.frm.select(name: 'document.newMaintainableObject.a21SubAccount.costShareChartOfAccountCode') }
  element(:cost_sharing_account_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.a21SubAccount.costShareSourceAccountNumber') }
  element(:cost_sharing_sub_account_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.a21SubAccount.costShareSourceSubAccountNumber') }

  element(:search_cost_sharing_chart_of_accounts_code) { |b| b.button(alt: 'Search Cost Sharing Chart of Accounts Code') }
  element(:search_cost_sharing_account_number) { |b| b.button(alt: 'Search Cost Sharing Account Number') }
  element(:search_cost_sharing_sub_account_number) { |b| b.button(alt: 'Search Cost Sharing Sub-Account Number') }

  #Edit CG ICR
  element(:icr_identifier) { |b| b.frm.text_field(name: 'document.newMaintainableObject.a21SubAccount.financialIcrSeriesIdentifier') }
  element(:icr_type_code) { |b| b.frm.select(name: 'document.newMaintainableObject.a21SubAccount.indirectCostRecoveryTypeCode') }
  element(:icr_off_campus_indicator) { |b| b.checkbox(name: 'document.newMaintainableObject.a21SubAccount.offCampusCode') }

  #Ad Hoc Recipients
  element(:ad_hoc_person) { |b| b.frm.text_field(name: 'newAdHocRoutePerson.id') }
  action(:ad_hoc_person_add) { |b| b.frm.button(name: 'methodToCall.insertAdHocRoutePerson').click }

  value(:chart_code_new) { |b| b.chart_code.exists? ? b.chart_code.value : b.chart_code_readonly }
  value(:account_number_new) { |b| b.account_number.exists? ? b.account_number.value : b.account_number_readonly }
  value(:sub_account_number_new) { |b| b.sub_account_number.exists? ? b.sub_account_number.value : b.sub_account_number_readonly }
  value(:name_new) { |b| b.name.exists? ? b.name.value : b.name_readonly }
  value(:active_indicator_new) { |b| b.active_indicator.exists? ? b.active_indicator.value : b.active_indicator_readonly }
  value(:sub_account_type_code_new) { |b| b.sub_account_type_code.exists? ? b.sub_account_type_code.selected_options.first.text : b.sub_account_type_code_readonly }
  value(:financial_reporting_chart_code_new) { |b| b.financial_reporting_chart_code.exists? ? b.financial_reporting_chart_code.value : b.financial_reporting_chart_code_readonly }
  value(:financial_reporting_org_code_new) { |b| b.financial_reporting_org_code.exists? ? b.financial_reporting_org_code.value : b.financial_reporting_org_code_readonly }
  value(:financial_reporting_code_new) { |b| b.financial_reporting_code.exists? ? b.financial_reporting_code.value : b.financial_reporting_code_readonly }
  value(:cost_sharing_chart_of_accounts_code_new) { |b| b.cost_sharing_chart_of_accounts_code.exists? ? b.cost_sharing_chart_of_accounts_code.selected_options.first.text : b.cost_sharing_chart_of_accounts_code_readonly }
  value(:cost_sharing_account_number_new) { |b| b.cost_sharing_account_number.exists? ? b.cost_sharing_account_number.value : b.cost_sharing_account_number_readonly }
  value(:cost_sharing_sub_account_number_new) { |b| b.cost_sharing_sub_account_number.exists? ? b.cost_sharing_sub_account_number.value : b.cost_sharing_sub_account_number_readonly }
  value(:icr_off_campus_indicator_new) { |b| b.icr_off_campus_indicator.exists? ? b.icr_off_campus_indicator.value : b.icr_off_campus_indicator_readonly }


  value(:sub_account_data_new) do |b|
    {
        chart_code:                           b.chart_code_new,
        account_number:                       b.account_number_new,
        sub_account_number:                   b.sub_account_number_new,
        name:                                 b.name_new,
        active_indicator:                     b.active_indicator_new,
        sub_account_type_code:                b.sub_account_type_code_new,
        financial_reporting_chart_code:       b.financial_reporting_chart_code_new,
        financial_reporting_org_code:         b.financial_reporting_org_code_new,
        financial_reporting_code:             b.financial_reporting_code_new,
        cost_sharing_chart_of_accounts_code:  b.cost_sharing_chart_of_accounts_code_new,
        cost_sharing_account_number:          b.cost_sharing_account_number_new,
        cost_sharing_sub_account_number:      b.cost_sharing_sub_account_number_new,
        icr_off_campus_indicator:             b.icr_off_campus_indicator_new

    }.merge(b.respond_to?(:sub_account_extended_data_new) ? b.sub_account_extended_data_new : Hash.new)
  end


  #Read Only
  value(:chart_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.chartOfAccountsCode.div').text.strip }
  value(:account_number_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.accountNumber.div').text.strip }
  value(:sub_account_number_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.subAccountNumber.div').text.strip }
  value(:name_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.subAccountName.div').text.strip }
  value(:active_indicator_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.active.div').text.strip }
  value(:sub_account_type_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.a21SubAccount.subAccountTypeCode.div').text.strip }
  value(:financial_reporting_chart_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.financialReportChartCode.div').text.strip }
  value(:financial_reporting_org_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.finReportOrganizationCode.div').text.strip }
  value(:financial_reporting_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.financialReportingCode.div').text.strip }
  value(:cost_sharing_chart_of_accounts_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.a21SubAccount.costShareChartOfAccountCode.div').text.strip }
  value(:cost_sharing_account_number_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.a21SubAccount.costShareSourceAccountNumber.div').text.strip }
  value(:cost_sharing_sub_account_number_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.a21SubAccount.costShareSourceSubAccountNumber.div').text.strip }
  value(:icr_identifier_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.a21SubAccount.financialIcrSeriesIdentifier.div').text.strip }
  value(:icr_type_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.a21SubAccount.indirectCostRecoveryTypeCode.div').text.strip }
  value(:icr_off_campus_indicator_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.a21SubAccount.offCampusCode.div').text.strip }

  value(:sub_account_data_readonly) do |b|
    {
        chart_code:                           b.chart_code_readonly,
        account_number:                       b.account_number_readonly,
        sub_account_number:                   b.sub_account_number_readonly,
        name:                                 b.name_readonly,
        active_indicator:                     b.active_indicator_readonly,
        sub_account_type_code:                b.sub_account_type_code_readonly,
        financial_reporting_chart_code:       b.financial_reporting_chart_code_readonly,
        financial_reporting_org_code:         b.financial_reporting_org_code_readonly,
        financial_reporting_code:             b.financial_reporting_code_readonly,
        cost_sharing_chart_of_accounts_code:  b.cost_sharing_chart_of_accounts_code_readonly,
        cost_sharing_account_number:          b.cost_sharing_account_number_readonly,
        cost_sharing_sub_account_number:      b.cost_sharing_sub_account_number_readonly,
        icr_off_campus_indicator:             b.icr_off_campus_indicator_readonly

    }.merge(b.respond_to?(:sub_account_extended_data_readonly) ? b.sub_account_extended_data_readonly : Hash.new)
  end

end