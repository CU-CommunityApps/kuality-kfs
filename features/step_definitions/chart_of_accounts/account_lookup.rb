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
  on AccountLookupPage do |page|
    case field_name
      when 'Account Manager Principal Name'
        page.acct_manager_principal_name.fit get_aft_parameter_value(ParameterConstants::DEFAULT_MANAGER)
      when 'Account Supervisor Principal Name'
        page.acct_supervisor_principal_name.fit get_aft_parameter_value(ParameterConstants::DEFAULT_SUPERVISOR)
    end
    page.search
  end
end