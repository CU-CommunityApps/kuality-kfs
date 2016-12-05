When /^I tab away from the Account Number field$/ do
  on SubAccountPage do |page|
    page.account_number.select
    page.account_number.send_keys :tab
  end
end

Then /^The Indirect Cost Rate ID field should not be null$/ do
  on(SubAccountPage).icr_identifier.value.should == ''
end

And /^I am logged in as the FO of the Sub-Account$/ do
  fiscal_officer_principal_name = get_fiscal_officer_principal_name_for_sub_account_number(@sub_account.account_number)
  step "I am logged in as \"#{fiscal_officer_principal_name}\""
  @user_id = fiscal_officer_principal_name
end

And /^The Sub-Account document should be in my action list$/ do
  sleep(5)
  on ActionList do |page|
    page.view_as(@user_id)
    page.last if on(ActionList).last_link.exists?
    page.result_item(@sub_account.document_id).should exist
  end
end

And /^I lookup the Sub-Account I want to edit$/ do
  visit(MainPage).sub_account
  on SubAccountLookupPage do |page|
    page.chart_code.fit           @sub_account.chart_code
    page.account_number.fit       @sub_account.account_number
    page.sub_account_number.fit   @sub_account.sub_account_number
    page.search
    # sub_account_number could be an alpha-numeric, Watir is not able to find the item in the table of values
    # returned by the lookup unless the sub_account_number matches even on case of letters (i.e. aBc != ABC)
    page.edit_item(@sub_account.sub_account_number.upcase)
  end
end

And /^I create a Sub-Account using a CG account with a CG Account Responsibility ID in range (.*) to (.*)$/ do |lower_limit, upper_limit|
  #method call should return an array
  account_numbers = find_cg_accounts_in_cg_responsibility_range(lower_limit, upper_limit)

  options = {
      chart_code:               get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE),
      account_number:           account_numbers.sample,
      name:                     generate_random_sub_account_name,
      sub_account_type_code:    get_aft_parameter_value(ParameterConstants::DEFAULT_EXPENSE_SUB_ACCOUNT_TYPE_CODE),
  }
  @sub_account = create SubAccountObject, options
end

And /^I edit the Sub-Account changing its type code to Cost Share$/ do
  options = {
      description:                          generate_random_description,
      sub_account_type_code:                get_aft_parameter_value(ParameterConstants::DEFAULT_COST_SHARE_SUB_ACCOUNT_TYPE_CODE),
      cost_sharing_account_number:          get_account_of_type('Cost Sharing Account'),
      cost_sharing_chart_of_accounts_code:  get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
  }

  @sub_account.edit options
end

And /^I create a Sub-Account with a Cost Share Sub-Account Type Code$/ do
  chart_code = get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
  cost_share_sub_fund_group_code = get_aft_parameter_value(ParameterConstants::DEFAULT_COST_SHARE_SUB_FUND_GROUP_CODE)
  account_number = get_account_number_for_cost_share_sub_account_with_sub_fund_group_code(cost_share_sub_fund_group_code, chart_code)
  options = {
      account_number:                      account_number,
      cost_sharing_chart_of_accounts_code: chart_code,
      sub_account_type_code:               get_aft_parameter_value(ParameterConstants::DEFAULT_COST_SHARE_SUB_ACCOUNT_TYPE_CODE),
      cost_sharing_account_number:         account_number
  }
  @sub_account = create SubAccountObject, options
end

And /^I edit the first active Indirect Cost Recovery Account on the Sub-Account to (a|an) (closed|open)(?: (.*))? Contracts & Grants Account$/ do |a_an_ind, open_closed_ind, expired_non_expired_ind|
  # do not continue, fail the test if there there is no icr_account to edit
  fail ArgumentError, 'No Indirect Cost Recovery Account on the Sub-Account, cannot edit. ' if @sub_account.icr_accounts.length == 0

  random_account_number = find_random_cg_account_number_having(open_closed_ind, expired_non_expired_ind)

  fail ArgumentError, "Cannot edit ICR Account on Sub-Account, WebService call did not return requested '#{open_closed_ind} #{expired_non_expired_ind} Contacts & Grants Acccount' required for this test." if random_account_number.nil? || random_account_number.empty?

  # Need to find first active ICR account as an inactive one could be anywhere in collection
  i = 0
  index_to_use = -1
  while i < @sub_account.icr_accounts.length and index_to_use == -1
    if @sub_account.icr_accounts[i].active_indicator == :set
      index_to_use = i
    end
    i+=1
  end

  # add values for the specified keys being edited for this single ICR account
  options = {
      account_number:         random_account_number,
      chart_of_accounts_code: get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
  }

  @sub_account.icr_accounts[index_to_use].edit options
end
