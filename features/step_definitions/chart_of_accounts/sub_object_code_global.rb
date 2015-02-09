# And /^I start an empty Sub-Object Code Global document$/ do
#   @sub_object_code_global = create SubObjectCodeGlobalObject
# end


When /^I add multiple account lines using an Organization Code$/ do
  step "I obtain #{ParameterConstants::TEST_CREATE_SUB_OBJ_CD_GBL_WITH_ORG_HIERARCHY} data values required for the test from the Parameter table"

  #do not continue if input data required for next step in test was not specified in the Parameter table
  fail ArgumentError, "Parameter #{ParameterConstants::TEST_CREATE_SUB_OBJ_CD_GBL_WITH_ORG_HIERARCHY} required for this test does not exist in the Parameter table." if @test_input_data.nil? || @test_input_data.empty?
  fail ArgumentError, "Parameter #{ParameterConstants::TEST_CREATE_SUB_OBJ_CD_GBL_WITH_ORG_HIERARCHY} does not specify required input test data value for organizationCode" if @test_input_data[:organizationCode].nil? || @test_input_data[:organizationCode].empty?

  @sub_object_code_global.add_multiple_account_lines(@test_input_data[:organizationCode])
end


# This step requires that the global hash @test_input_data exist and hold the input data required.
Then /^retrieved accounts equal all Active Accounts for these Organization Codes$/ do
  organization_code = get_aft_parameter_value(ParameterConstants::TEST_CREATE_SUB_OBJ_CD_GBL_WITH_ORG_HIERARCHY)
  #get the accounts we should validate against
  accounts_hash = get_kuali_business_objects('KFS-COA','Account',"organizationCode=#{organization_code}&closed=N")
  accounts = accounts_hash['org.kuali.kfs.coa.businessobject.Account']

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
