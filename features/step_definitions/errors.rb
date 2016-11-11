Then /^the document should have no errors$/ do
  $current_page.errors.should == []
end

Then /^The document should save successfully$/ do
  $current_page.left_errmsg_text.should include 'Document was successfully saved.'
  $current_page.document_status.should == 'SAVED'
end

Then /^I should get an error saying "([^"]*)"$/ do |error_msg|
  $current_page.errors.should include error_msg
end

Then /^I should get an error that starts with "([^"]*)"$/ do |error_msg|
  #getting errors from page is expensive, obtain reference once that can be reused
  page_errors = $current_page.errors
  #we are expecting an error message, fail when there are none
  page_errors.empty?.should_not == true
  #search for what we are looking for
  exists = page_errors.any? { |s| s.include?(error_msg) }
  #we are expecting our error message to be there, fail if it is not
  exists.should == true
end

And /^I should get an Authorization Exception Report error$/ do
  $current_page.frm.div(id: 'headerarea').h1.text.rstrip.should == 'Authorization Exception Report'
end

And /^I should not get an Authorization Exception Report error$/ do
  $current_page.frm.div(id: 'headerarea').h1.text.rstrip.should_not == 'Authorization Exception Report'
end

Then /^the (.*) should show an error stating the Indirect Cost Recovery Account is closed$/ do |document|
  error_msg = "Indirect Cost Recovery Account #{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}-#{@closed_account_number_used_for_icr_account_number} is closed."
  $current_page.errors.should include error_msg
end
