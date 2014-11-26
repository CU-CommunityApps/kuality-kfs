class AccountGlobalPage < KFSBasePage

  element(:new_chart_code) { |b| b.frm.select(name: 'document.newMaintainableObject.add.accountGlobalDetails.chartOfAccountsCode') }
  element(:new_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.add.accountGlobalDetails.accountNumber') }
  action(:add_account_detail) { |b| b.frm.button(name: /^methodToCall.addLine.accountGlobalDetails/).click }

  element(:fo_principal_name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountFiscalOfficerUser.principalName') }
  element(:supervisor_principal_name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountSupervisoryUser.principalName') }
  element(:manager_principal_name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountManagerUser.principalName') }
  element(:organization_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.organizationCode') }
  element(:sub_fund_group_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.subFundGroupCode') }
  element(:acct_expire_date) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountExpirationDate') }
  element(:postal_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountZipCode') }
  element(:city) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountCityName') }
  element(:state) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountStateCode') }
  element(:address) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountStreetAddress') }
  element(:continuation_coa_code) { |b| b.frm.select(name: 'document.newMaintainableObject.continuationFinChrtOfAcctCd') }
  element(:continuation_acct_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.continuationAccountNumber') }
  element(:income_stream_financial_cost_code) { |b| b.frm.select(name: 'document.newMaintainableObject.incomeStreamFinancialCoaCode') }
  element(:income_stream_account_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.incomeStreamAccountNumber') }
  element(:cfda_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountCfdaNumber') }
  element(:higher_ed_funct_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.financialHigherEdFunctionCd') }
  element(:sufficient_funds_code) { |b| b.frm.select(name: 'document.newMaintainableObject.accountSufficientFundsCode') }
  element(:trans_processing_sufficient_funds_code) { |b| b.frm.select(name: 'document.newMaintainableObject.pendingAcctSufficientFundsIndicator') }
  element(:labor_benefit_rate_category_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.laborBenefitRateCategoryCode') }


  value(:fo_principal_name_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.accountFiscalOfficerUser.principalName.div').text.strip }
  value(:supervisor_principal_name_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.accountSupervisoryUser.principalName.div').text.strip }
  value(:manager_principal_name_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.accountManagerUser.principalName.div').text.strip }
  value(:organization_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.organizationCode.div').text.strip }
  value(:sub_fund_group_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.subFundGroupCode.div').text.strip }
  value(:acct_expire_date_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.accountExpirationDate.div').text.strip }
  value(:postal_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.accountZipCode.div').text.strip }
  value(:city_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.accountCityName.div').text.strip }
  value(:state_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.accountStateCode.div').text.strip }
  value(:address_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.accountStreetAddress.div').text.strip }
  value(:continuation_coa_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.continuationFinChrtOfAcctCd.div').text.strip }
  value(:continuation_acct_number_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.continuationAccountNumber.div').text.strip }
  value(:income_stream_financial_cost_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.incomeStreamFinancialCoaCode.div').text.strip }
  value(:income_stream_account_number_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.incomeStreamAccountNumber.div').text.strip }
  value(:cfda_number_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.accountCfdaNumber.div').text.strip }
  value(:higher_ed_funct_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.financialHigherEdFunctionCd.div').text.strip }
  value(:sufficient_funds_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.accountSufficientFundsCode.div').text.strip }
  value(:trans_processing_sufficient_funds_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.pendingAcctSufficientFundsIndicator.div').text.strip }
  value(:labor_benefit_rate_category_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.laborBenefitRateCategoryCode.div').text.strip }

  value(:fo_principal_name_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountFiscalOfficerUser.principalName.div').text.strip }
  value(:supervisor_principal_name_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountSupervisoryUser.principalName.div').text.strip }
  value(:manager_principal_name_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountManagerUser.principalName.div').text.strip }
  value(:organization_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.organizationCode.div').text.strip }
  value(:sub_fund_group_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.subFundGroupCode.div').text.strip }
  value(:acct_expire_date_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountExpirationDate.div').text.strip }
  value(:postal_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountZipCode.div').text.strip }
  value(:city_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountCityName.div').text.strip }
  value(:state_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountStateCode.div').text.strip }
  value(:address_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountStreetAddress.div').text.strip }
  value(:continuation_coa_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.continuationFinChrtOfAcctCd.div').text.strip }
  value(:continuation_acct_number_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.continuationAccountNumber.div').text.strip }
  value(:income_stream_financial_cost_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.incomeStreamFinancialCoaCode.div').text.strip }
  value(:income_stream_account_number_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.incomeStreamAccountNumber.div').text.strip }
  value(:cfda_number_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountCfdaNumber.div').text.strip }
  value(:higher_ed_funct_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.financialHigherEdFunctionCd.div').text.strip }
  value(:sufficient_funds_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountSufficientFundsCode.div').text.strip }
  value(:trans_processing_sufficient_funds_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.pendingAcctSufficientFundsIndicator.div').text.strip }
  value(:labor_benefit_rate_category_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.laborBenefitRateCategoryCode.div').text.strip }

  value(:fo_principal_name_new) { |b| b.fo_principal_name.exists? ? b.fo_principal_name.value : b.fo_principal_name_readonly }
  value(:supervisor_principal_name_new) { |b| b.supervisor_principal_name.exists? ? b.supervisor_principal_name.value : b.supervisor_principal_name_readonly }
  value(:manager_principal_name_new) { |b| b.manager_principal_name.exists? ? b.manager_principal_name.value : b.manager_principal_name_readonly }
  value(:organization_code_new) { |b| b.organization_code.exists? ? b.organization_code.value : b.organization_code_readonly }
  value(:sub_fund_group_code_new) { |b| b.sub_fund_group_code.exists? ? b.sub_fund_group_code.value : b.sub_fund_group_code_readonly }
  value(:acct_expire_date_new) { |b| b.acct_expire_date.exists? ? b.acct_expire_date.value : b.acct_expire_date_readonly }
  value(:postal_code_new) { |b| b.postal_code.exists? ? b.postal_code.value : b.postal_code_readonly }
  value(:city_new) { |b| b.city.exists? ? b.city.value : b.city_readonly }
  value(:state_new) { |b| b.state.exists? ? b.state.value : b.state_readonly }
  value(:address_new) { |b| b.address.exists? ? b.address.value : b.address_readonly }
  value(:continuation_coa_code_new) { |b| b.continuation_coa_code.exists? ? b.continuation_coa_code.value : b.continuation_coa_code_readonly }
  value(:continuation_acct_number_new) { |b| b.continuation_acct_number.exists? ? b.continuation_acct_number.value : b.continuation_acct_number_readonly }
  value(:income_stream_financial_cost_code_new) { |b| b.income_stream_financial_cost_code.exists? ? b.income_stream_financial_cost_code.selected_options.first.text : b.income_stream_financial_cost_code_readonly }
  value(:income_stream_account_number_new) { |b| b.income_stream_account_number.exists? ? b.income_stream_account_number.value : b.income_stream_account_number_readonly }
  value(:cfda_number_new) { |b| b.cfda_number.exists? ? b.cfda_number.value : b.cfda_number_readonly }
  value(:higher_ed_funct_code_new) { |b| b.higher_ed_funct_code.exists? ? b.higher_ed_funct_code.value : b.higher_ed_funct_code_readonly }
  value(:sufficient_funds_code_new) { |b| b.sufficient_funds_code.exists? ? b.sufficient_funds_code.selected_options.first.text : b.sufficient_funds_code_readonly }
  value(:trans_processing_sufficient_funds_code_new) { |b| b.trans_processing_sufficient_funds_code.exists? ? b.trans_processing_sufficient_funds_code.selected_options.first.text : b.trans_processing_sufficient_funds_code_readonly }
  value(:labor_benefit_rate_category_code_new) { |b| b.labor_benefit_rate_category_code.exists? ? b.labor_benefit_rate_category_code.value : b.labor_benefit_rate_category_code_readonly }

end