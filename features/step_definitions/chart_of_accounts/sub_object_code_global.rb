And /^I start an empty Sub-Object Code Global document$/ do
  @sub_object_code_global = create SubObjectCodeGlobalObject
end


When /^I add multiple account lines to the Sub Object Code Global document using an Organization Code$/ do
  step "I obtain #{ParameterConstants::TEST_CREATE_SUB_OBJ_CD_GBL_WITH_ORG_HIERARCHY} data values required for the test from the Parameter table"

  #do not continue if input data required for next step in test was not specified in the Parameter table
  fail ArgumentError, "Parameter #{ParameterConstants::TEST_CREATE_SUB_OBJ_CD_GBL_WITH_ORG_HIERARCHY} required for this test does not exist in the Parameter table." if @test_input_data.nil? || @test_input_data.empty?
  fail ArgumentError, "Parameter #{ParameterConstants::TEST_CREATE_SUB_OBJ_CD_GBL_WITH_ORG_HIERARCHY} does not specify required input test data value for organization_code" if @test_input_data[:organization_code].nil? || @test_input_data[:organization_code].empty?

  @sub_object_code_global.add_multiple_account_lines(@test_input_data[:organization_code])
end


# This step requires that the global hash @test_input_data exist and hold the input data required.
Then /^retrieved accounts equal all Active Accounts for the Organization Code$/ do
  # get the accounts we should validate against using the previously obtained test_input_data values
  accounts = get_all_active_accounts_for_organization_code(@test_input_data[:organization_code])

  #ensure accounts were found
  accounts.nil?.should_not
  accounts.empty?.should_not

  #for speed, obtain this value once and use it multiple times in sub-sequent loop
  default_chart = get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)

  #validate page contents matches all active accounts with the specified org code
  accounts.each do |an_account_object|
    an_account_number = an_account_object['accountNumber'][0]
    on(SubObjectCodeGlobalPage).verify_account_number(default_chart, an_account_number).should exist
  end
end
