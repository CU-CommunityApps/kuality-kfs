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
