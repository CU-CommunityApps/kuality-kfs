class AccountPage < KFSBasePage

  element(:chart_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.chartOfAccountsCode') }
  element(:number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountNumber') }
  element(:name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountName') }
  element(:organization_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.organizationCode') }
  element(:campus_code) { |b| b.frm.select(name: 'document.newMaintainableObject.accountPhysicalCampusCode') }
  element(:effective_date) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountEffectiveDate') }
  element(:postal_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountZipCode') }
  element(:city) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountCityName') }
  element(:state) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountStateCode') }
  element(:address) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountStreetAddress') }
  element(:type_code) { |b| b.frm.select(name: 'document.newMaintainableObject.accountTypeCode') }
  element(:sub_fund_group_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.subFundGroupCode') }
  element(:higher_ed_funct_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.financialHigherEdFunctionCd') }
  element(:restricted_status_code) { |b| b.frm.select(name: 'document.newMaintainableObject.accountRestrictedStatusCode') }
  element(:fo_principal_name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountFiscalOfficerUser.principalName') }
  element(:supervisor_principal_name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountSupervisoryUser.principalName') }
  element(:manager_principal_name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountManagerUser.principalName') }
  element(:budget_record_level_code) { |b| b.frm.select(name: 'document.newMaintainableObject.budgetRecordingLevelCode') }
  element(:sufficient_funds_code) { |b| b.frm.select(name: 'document.newMaintainableObject.accountSufficientFundsCode') }
  element(:expense_guideline_text) { |b| b.frm.textarea(name: 'document.newMaintainableObject.accountGuideline.accountExpenseGuidelineText') }
  element(:income_guideline_text) { |b| b.frm.textarea(name: 'document.newMaintainableObject.accountGuideline.accountIncomeGuidelineText') }
  element(:purpose_text) { |b| b.frm.textarea(name: 'document.newMaintainableObject.accountGuideline.accountPurposeText') }
  element(:closed) { |b| b.frm.checkbox(name: 'document.newMaintainableObject.closed') }
  element(:continuation_chart_code) { |b| b.frm.select(name: 'document.newMaintainableObject.continuationFinChrtOfAcctCd') }
  element(:continuation_account_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.continuationAccountNumber') }
  element(:account_expiration_date) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountExpirationDate') }

  element(:contract_control_chart_of_accounts_code) { |b| b.frm.select(name: 'document.newMaintainableObject.contractControlFinCoaCode') }
  element(:contract_control_account_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.contractControlAccountNumber') }
  element(:account_icr_type_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.acctIndirectCostRcvyTypeCd') }
  element(:indirect_cost_rate) { |b| b.frm.text_field(name: 'document.newMaintainableObject.financialIcrSeriesIdentifier') }
  element(:cfda_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountCfdaNumber') }
  element(:cg_account_responsibility_id) { |b| b.frm.select(name: 'document.newMaintainableObject.contractsAndGrantsAccountResponsibilityId') }

  element(:income_stream_financial_cost_code) { |b| b.frm.select(name: 'document.newMaintainableObject.incomeStreamFinancialCoaCode') }
  element(:income_stream_account_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.incomeStreamAccountNumber') }

  # New
  value(:new_chart_code) { |b| b.chart_code.exists? ? b.chart_code.value : b.readonly_chart_code }
  value(:new_number) { |b| b.number.exists? ? b.number.value : b.readonly_number }
  value(:new_name) { |b| b.name.exists? ? b.name.value : b.readonly_name }
  value(:new_organization_code) { |b| b.organization_code.exists? ? b.organization_code.value : b.readonly_organization_code }
  value(:new_campus_code) { |b| b.campus_code.exists? ? b.campus_code.selected_options.first.text : b.readonly_campus_code }
  value(:new_effective_date) { |b| b.effective_date.exists? ? b.effective_date.value : b.readonly_effective_date }
  value(:new_postal_code) { |b| b.postal_code.exists? ? b.postal_code.value : b.readonly_postal_code }
  value(:new_city) { |b| b.city.exists? ? b.city.value : b.readonly_city }
  value(:new_state) { |b| b.state.exists? ? b.state.value : b.readonly_state }
  value(:new_address) { |b| b.address.exists? ? b.address.value : b.readonly_address }
  value(:new_type_code) { |b| b.type_code.exists? ? b.type_code.selected_options.first.text : b.readonly_type_code }
  value(:new_sub_fund_group_code) { |b| b.sub_fund_group_code.exists? ? b.sub_fund_group_code.value : b.readonly_sub_fund_group_code }
  value(:new_higher_ed_funct_code) { |b| b.higher_ed_funct_code.exists? ? b.higher_ed_funct_code.value : b.readonly_higher_ed_funct_code }
  value(:new_restricted_status_code) { |b| b.restricted_status_code.exists? ? b.restricted_status_code.selected_options.first.text : b.readonly_restricted_status_code }
  value(:new_fo_principal_name) { |b| b.fo_principal_name.exists? ? b.fo_principal_name.value : b.readonly_fo_principal_name }
  value(:new_supervisor_principal_name) { |b| b.supervisor_principal_name.exists? ? b.supervisor_principal_name.value : b.readonly_supervisor_principal_name }
  value(:new_manager_principal_name) { |b| b.manager_principal_name.exists? ? b.manager_principal_name.value : b.readonly_manager_principal_name }
  value(:new_budget_record_level_code) { |b| b.budget_record_level_code.exists? ? b.budget_record_level_code.selected_options.first.text : b.readonly_budget_record_level_code }
  value(:new_sufficient_funds_code) { |b| b.sufficient_funds_code.exists? ? b.sufficient_funds_code.selected_options.first.text : b.readonly_sufficient_funds_code }
  value(:new_expense_guideline_text) { |b| b.expense_guideline_text.exists? ? b.expense_guideline_text.value : b.readonly_expense_guideline_text }
  value(:new_income_guideline_text) { |b| b.income_guideline_text.exists? ? b.income_guideline_text.value : b.readonly_income_guideline_text }
  value(:new_purpose_text) { |b| b.purpose_text.exists? ? b.purpose_text.value : b.readonly_purpose_text }
  value(:new_income_stream_financial_cost_code) { |b| b.income_stream_financial_cost_code.exists? ? b.income_stream_financial_cost_code.selected_options.first.text : b.readonly_income_stream_financial_cost_code }
  value(:new_income_stream_account_number) { |b| b.income_stream_account_number.exists? ? b.income_stream_account_number.value : b.readonly_income_stream_account_number }
  value(:new_account_expiration_date) { |b| b.account_expiration_date.exists? ? b.account_expiration_date.value : b.readonly_account_expiration_date }
  value(:new_contract_control_chart_of_accounts_code) { |b| b.contract_control_chart_of_accounts_code.exists? ? b.contract_control_chart_of_accounts_code.selected_options.first.text : b.readonly_contract_control_chart_of_accounts_code }
  value(:new_contract_control_account_number) { |b| b.contract_control_account_number.exists? ? b.contract_control_account_number.value : b.readonly_contract_control_account_number }
  value(:new_account_icr_type_code) { |b| b.account_icr_type_code.exists? ? b.account_icr_type_code.value : b.readonly_account_icr_type_code }
  value(:new_indirect_cost_rate) { |b| b.indirect_cost_rate.exists? ? b.indirect_cost_rate.value : b.readonly_indirect_cost_rate }
  value(:new_cfda_number) { |b| b.cfda_number.exists? ? b.cfda_number.value : b.readonly_cfda_number }
  value(:new_cg_account_responsibility_id) { |b| b.cg_account_responsibility_id.exists? ? b.cg_account_responsibility_id.value : b.readonly_cg_account_responsibility_id }

  value(:new_account_data) do |b|
    {
      chart_code:                b.new_chart_code,
      number:                    b.new_number,
      name:                      b.new_name,
      organization_code:         b.new_organization_code,
      campus_code:               b.new_campus_code,
      effective_date:            b.new_effective_date,
      postal_code:               b.new_postal_code,
      city:                      b.new_city,
      state:                     b.new_state,
      address:                   b.new_address,
      type_code:                 b.new_type_code,
      sub_fund_group_code:       b.new_sub_fund_group_code,
      higher_ed_funct_code:      b.new_higher_ed_funct_code,
      restricted_status_code:    b.new_restricted_status_code,
      fo_principal_name:         b.new_fo_principal_name,
      supervisor_principal_name: b.new_supervisor_principal_name,
      manager_principal_name:    b.new_manager_principal_name,
      budget_record_level_code:  b.new_budget_record_level_code,
      sufficient_funds_code:     b.new_sufficient_funds_code,
      expense_guideline_text:    b.new_expense_guideline_text,
      income_guideline_text:     b.new_income_guideline_text,
      purpose_text:              b.new_purpose_text,
      income_stream_financial_cost_code: b.new_income_stream_financial_cost_code,
      income_stream_account_number:      b.new_income_stream_account_number,
      account_expiration_date:           b.new_account_expiration_date,
      contract_control_chart_of_accounts_code: b.new_contract_control_chart_of_accounts_code,
      contract_control_account_number:         b.new_contract_control_account_number,
      account_icr_type_code:                   b.new_account_icr_type_code,
      indirect_cost_rate:                      b.new_indirect_cost_rate,
      cfda_number:                             b.new_cfda_number,
      cg_account_responsibility_id:            b.new_cg_account_responsibility_id
    }.merge(b.respond_to?(:new_account_extended_data) ? b.new_account_extended_data : Hash.new)
  end

  # Old
  value(:old_chart_code) { |b| b.frm.span(id: 'document.oldMaintainableObject.chartOfAccountsCode.div').text.strip }
  value(:old_account_number) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountNumber.div').text.strip }
  alias_method :old_number, :old_account_number
  value(:old_name) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountName.div').text.strip }
  value(:old_organization_code) { |b| b.frm.span(id: 'document.oldMaintainableObject.organizationCode.div').text.strip }
  value(:old_campus_code) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountPhysicalCampusCode.div').text.strip }
  value(:old_effective_date) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountEffectiveDate.div').text.strip }
  value(:old_postal_code) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountZipCode.div').text.strip }
  value(:old_city) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountCityName.div').text.strip }
  value(:old_state) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountStateCode.div').text.strip }
  value(:old_address) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountStreetAddress.div').text.strip }
  value(:old_type_code) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountTypeCode.div').text.strip }
  value(:old_sub_fund_group_code) { |b| b.frm.span(id: 'document.oldMaintainableObject.subFundGroupCode.div').text.strip }
  value(:old_higher_ed_funct_code) { |b| b.frm.span(id: 'document.oldMaintainableObject.financialHigherEdFunctionCd.div').text.strip }
  value(:old_restricted_status_code) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountRestrictedStatusCode.div').text.strip }
  value(:old_fo_principal_name) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountFiscalOfficerUser.name.div').parent.links[0].text.strip }
  value(:old_supervisor_principal_name) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountSupervisoryUser.name.div').parent.links[0].text.strip }
  value(:old_manager_principal_name) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountManagerUser.name.div').parent.links[0].text.strip }
  value(:old_budget_record_level_code) { |b| b.frm.span(id: 'document.oldMaintainableObject.budgetRecordingLevelCode.div').text.strip }
  value(:old_sufficient_funds_code) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountSufficientFundsCode.div').text.strip }
  value(:old_expense_guideline_text) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountGuideline.accountExpenseGuidelineText.div').text.strip }
  value(:old_income_guideline_text) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountGuideline.accountIncomeGuidelineText.div').text.strip }
  value(:old_purpose_text) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountGuideline.accountPurposeText.div').text.strip }
  value(:old_income_stream_financial_cost_code) { |b| b.frm.span(id: 'document.oldMaintainableObject.incomeStreamFinancialCoaCode.div').text.strip }
  value(:old_income_stream_account_number) { |b| b.frm.span(id: 'document.oldMaintainableObject.incomeStreamAccountNumber.div').text.strip }
  value(:old_account_expiration_date) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountExpirationDate.div').text.strip }
  value(:old_contract_control_chart_of_accounts_code) { |b| b.frm.span(id: 'document.oldMaintainableObject.contractControlFinCoaCode.div').text.strip }
  value(:old_contract_control_account_number) { |b| b.frm.span(id: 'document.oldMaintainableObject.contractControlAccountNumber.div').text.strip }
  value(:old_account_icr_type_code) { |b| b.frm.span(id: 'document.oldMaintainableObject.acctIndirectCostRcvyTypeCd.div').text.strip }
  value(:old_indirect_cost_rate) { |b| b.frm.span(id: 'document.oldMaintainableObject.financialIcrSeriesIdentifier.div').text.strip }
  value(:old_cfda_number) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountCfdaNumber.div').text.strip }
  value(:old_cg_account_responsibility_id) { |b| b.frm.span(id: 'document.oldMaintainableObject.contractsAndGrantsAccountResponsibilityId.div').text.strip }

  value(:old_account_data) do |b|
    {
      chart_code:                b.old_chart_code,
      number:                    b.old_number,
      name:                      b.old_name,
      organization_code:         b.old_organization_code,
      campus_code:               b.old_campus_code,
      effective_date:            b.old_effective_date,
      postal_code:               b.old_postal_code,
      city:                      b.old_city,
      state:                     b.old_state,
      address:                   b.old_address,
      type_code:                 b.old_type_code,
      sub_fund_group_code:       b.old_sub_fund_group_code,
      higher_ed_funct_code:      b.old_higher_ed_funct_code,
      restricted_status_code:    b.old_restricted_status_code,
      fo_principal_name:         b.old_fo_principal_name,
      supervisor_principal_name: b.old_supervisor_principal_name,
      manager_principal_name:    b.old_manager_principal_name,
      budget_record_level_code:  b.old_budget_record_level_code,
      sufficient_funds_code:     b.old_sufficient_funds_code,
      expense_guideline_text:    b.old_expense_guideline_text,
      income_guideline_text:     b.old_income_guideline_text,
      purpose_text:              b.old_purpose_text,
      income_stream_financial_cost_code: b.old_income_stream_financial_cost_code,
      income_stream_account_number:      b.old_income_stream_account_number,
      account_expiration_date:           b.old_account_expiration_date,
      contract_control_chart_of_accounts_code: b.old_contract_control_chart_of_accounts_code,
      contract_control_account_number:         b.old_contract_control_account_number,
      account_icr_type_code:                   b.old_account_icr_type_code,
      indirect_cost_rate:                      b.old_indirect_cost_rate,
      cfda_number:                             b.old_cfda_number,
      cg_account_responsibility_id:            b.old_cg_account_responsibility_id,
      invoice_frequency_code:                  b.old_invoice_frequency_code,
      invoice_type_code:                       b.old_invoice_type_code
    }.merge(b.respond_to?(:old_account_extended_data) ? b.old_account_extended_data : Hash.new)
  end

  # Read-Only
  value(:readonly_chart_code) { |b| b.frm.span(id: 'document.newMaintainableObject.chartOfAccountsCode.div').text.strip }
  value(:readonly_number) { |b| b.frm.span(id: 'document.newMaintainableObject.accountNumber.div').text.strip }
  value(:readonly_name) { |b| b.frm.span(id: 'document.newMaintainableObject.accountName.div').text.strip }
  value(:readonly_organization_code) { |b| b.frm.span(id: 'document.newMaintainableObject.organizationCode.div').text.strip }
  value(:readonly_campus_code) { |b| b.frm.span(id: 'document.newMaintainableObject.accountPhysicalCampusCode.div').text.strip }
  value(:readonly_effective_date) { |b| b.frm.span(id: 'document.newMaintainableObject.accountEffectiveDate.div').text.strip }
  value(:readonly_postal_code) { |b| b.frm.span(id: 'document.newMaintainableObject.accountZipCode.div').text.strip }
  value(:readonly_city) { |b| b.frm.span(id: 'document.newMaintainableObject.accountCityName.div').text.strip }
  value(:readonly_state) { |b| b.frm.span(id: 'document.newMaintainableObject.accountStateCode.div').text.strip }
  value(:readonly_address) { |b| b.frm.span(id: 'document.newMaintainableObject.accountStreetAddress.div').text.strip }
  value(:readonly_type_code) { |b| b.frm.span(id: 'document.newMaintainableObject.accountTypeCode.div').text.strip }
  value(:readonly_sub_fund_group_code) { |b| b.frm.span(id: 'document.newMaintainableObject.subFundGroupCode.div').text.strip }
  value(:readonly_higher_ed_funct_code) { |b| b.frm.span(id: 'document.newMaintainableObject.financialHigherEdFunctionCd.div').text.strip }
  value(:readonly_restricted_status_code) { |b| b.frm.span(id: 'document.newMaintainableObject.accountRestrictedStatusCode.div').text.strip }
  value(:readonly_fo_principal_name) { |b| b.frm.span(id: 'document.newMaintainableObject.accountFiscalOfficerUser.name.div').parent.links[0].text.strip }
  value(:readonly_supervisor_principal_name) { |b| b.frm.span(id: 'document.newMaintainableObject.accountSupervisoryUser.name.div').parent.links[0].text.strip }
  value(:readonly_manager_principal_name) { |b| b.frm.span(id: 'document.newMaintainableObject.accountManagerUser.name.div').parent.links[0].text.strip }
  value(:readonly_budget_record_level_code) { |b| b.frm.span(id: 'document.newMaintainableObject.budgetRecordingLevelCode.div').text.strip }
  value(:readonly_sufficient_funds_code) { |b| b.frm.span(id: 'document.newMaintainableObject.accountSufficientFundsCode.div').text.strip }
  value(:readonly_expense_guideline_text) { |b| b.frm.span(id: 'document.newMaintainableObject.accountGuideline.accountExpenseGuidelineText.div').text.strip }
  value(:readonly_income_guideline_text) { |b| b.frm.span(id: 'document.newMaintainableObject.accountGuideline.accountIncomeGuidelineText.div').text.strip }
  value(:readonly_purpose_text) { |b| b.frm.span(id: 'document.newMaintainableObject.accountGuideline.accountPurposeText.div').text.strip }
  value(:readonly_income_stream_financial_cost_code) { |b| b.frm.span(id: 'document.newMaintainableObject.incomeStreamFinancialCoaCode.div').text.strip }
  value(:readonly_income_stream_account_number) { |b| b.frm.span(id: 'document.newMaintainableObject.incomeStreamAccountNumber.div').text.strip }
  value(:readonly_account_expiration_date) { |b| b.frm.span(id: 'document.newMaintainableObject.accountExpirationDate.div').text.strip }
  value(:readonly_contract_control_chart_of_accounts_code) { |b| b.frm.span(id: 'document.newMaintainableObject.contractControlFinCoaCode.div').text.strip }
  value(:readonly_contract_control_account_number) { |b| b.frm.span(id: 'document.newMaintainableObject.contractControlAccountNumber.div').text.strip }
  value(:readonly_account_icr_type_code) { |b| b.frm.span(id: 'document.newMaintainableObject.acctIndirectCostRcvyTypeCd.div').text.strip }
  value(:readonly_indirect_cost_rate) { |b| b.frm.span(id: 'document.newMaintainableObject.financialIcrSeriesIdentifier.div').text.strip }
  value(:readonly_cfda_number) { |b| b.frm.span(id: 'document.newMaintainableObject.accountCfdaNumber.div').text.strip }
  value(:readonly_cg_account_responsibility_id) { |b| b.frm.span(id: 'document.newMaintainableObject.contractsAndGrantsAccountResponsibilityId.div').text.strip }

  value(:readonly_account_data) do |b|
    {
        chart_code:                b.readonly_chart_code,
        number:                    b.readonly_number,
        name:                      b.readonly_name,
        organization_code:         b.readonly_organization_code,
        campus_code:               b.readonly_campus_code,
        effective_date:            b.readonly_effective_date,
        postal_code:               b.readonly_postal_code,
        city:                      b.readonly_city,
        state:                     b.readonly_state,
        address:                   b.readonly_address,
        type_code:                 b.readonly_type_code,
        sub_fund_group_code:       b.readonly_sub_fund_group_code,
        higher_ed_funct_code:      b.readonly_higher_ed_funct_code,
        restricted_status_code:    b.readonly_restricted_status_code,
        fo_principal_name:         b.readonly_fo_principal_name,
        supervisor_principal_name: b.readonly_supervisor_principal_name,
        manager_principal_name:    b.readonly_manager_principal_name,
        budget_record_level_code:  b.readonly_budget_record_level_code,
        sufficient_funds_code:     b.readonly_sufficient_funds_code,
        expense_guideline_text:    b.readonly_expense_guideline_text,
        income_guideline_text:     b.readonly_income_guideline_text,
        purpose_text:              b.readonly_purpose_text,
        income_stream_financial_cost_code: b.readonly_income_stream_financial_cost_code,
        income_stream_account_number:      b.readonly_income_stream_account_number,
        account_expiration_date:           b.readonly_account_expiration_date,
        contract_control_chart_of_accounts_code: b.readonly_contract_control_chart_of_accounts_code,
        contract_control_account_number:         b.readonly_contract_control_account_number,
        account_icr_type_code:                   b.readonly_account_icr_type_code,
        indirect_cost_rate:                      b.readonly_indirect_cost_rate,
        cfda_number:                             b.readonly_cfda_number,
        cg_account_responsibility_id:            b.readonly_cg_account_responsibility_id,
        invoice_frequency_code:                  b.readonly_invoice_frequency_code,
        invoice_type_code:                       b.readonly_invoice_type_code
    }.merge(b.respond_to?(:readonly_account_extended_data) ? b.readonly_account_extended_data : Hash.new)
  end

  value(:account_maintenance_errors) { |b| b.frm.div(id: 'tab-AccountMaintenance-div').div(class: 'left-errmsg-tab').div.divs.collect{ |div| div.text }  }

  element(:error_icon) { |b| b.frm.image(alt: 'error') }

end