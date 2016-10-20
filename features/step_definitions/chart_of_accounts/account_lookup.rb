When /^I access Account Lookup$/ do
  visit(MainPage).account
end

Then /^the Account Lookup page should appear$/ do
  on(AccountLookupPage).chart_code.should exist
end

When /^I search for all accounts$/ do
  on(AccountLookupPage) do |page|
    page.search
    page.wait_for_search_results
  end
end

When /^Accounts should be returned$/ do
  # Selenium::WebDriver::Error::StaleElementReferenceError is generated when a "page.results_table.should exist"
  # check is performed to determine whether we got search results and no results table is returned; therefore, a
  # multi-check is need to deal with the multiple widgets that can be returned.
  on(AccountLookupPage) do |page|
    if page.results_returned?
      # something was returned, could be actual data or phrases no data found
      if page.no_values_match_this_search.nil? and page.no_results_found.nil?
        # SUCCESS, we got account data
        true.should == true
      else
        # fail the test, got a phrase that there was no data
        true.should == false
      end
    else
      # fail the test, search returned nothing
      true.should == false
    end
  end
end

When /^I lookup an Account with (.*)$/ do |field_name|

  @test_data_parameter_name = 'TEST_ACCOUNT_LOOKUP_CORNELL_SPECIFIC_FIELDS'
  step "I obtain #{@test_data_parameter_name} data values required for the test from the Parameter table"
  #do not continue if input data required for next step in test was not specified in the Parameter table
  fail ArgumentError, "Parameter #{@test_data_parameter_name} required for this test does not exist in the Parameter table." if @test_input_data.nil? || @test_input_data.empty?

  on AccountLookupPage do |page|
    case field_name
      when 'Account Manager Principal Name'
        # Only continue if data needed for test is specified in parameter
        fail ArgumentError, "Parameter #{@test_data_parameter_name} does not specify required input test data value for account manager principal name" if @test_input_data[:acct_manager_principal_name].nil? || @test_input_data[:acct_manager_principal_name].empty?
        page.acct_manager_principal_name.fit @test_input_data[:acct_manager_principal_name]
      when 'Account Supervisor Principal Name'
        # Only continue if data needed for test is specified in parameter
        fail ArgumentError, "Parameter #{@test_data_parameter_name} does not specify required input test data value for account supervisor principal name" if @test_input_data[:acct_supervisor_principal_name].nil? || @test_input_data[:acct_supervisor_principal_name].empty?
        page.acct_supervisor_principal_name.fit @test_input_data[:acct_supervisor_principal_name]
      else
        fail ArgumentError, "Step I lookup an Account with #{field_name} is not coded to handle that field name."
    end
    page.search
  end
end



Then /^the Account Lookup page should appear with Cornell custom fields$/ do
  on AccountLookupPage do |page|
    page.responsibility_center_code.should exist
    page.reports_to_org_code.should exist
    page.reports_to_coa_code.should exist
    page.fund_group_code.should exist
    page.subfund_program_code.should exist
    page.appropriation_acct_number.should exist
    page.major_reporting_category_code.should exist
    page.acct_manager_principal_name.should exist
    page.acct_supervisor_principal_name.should exist
  end
end
