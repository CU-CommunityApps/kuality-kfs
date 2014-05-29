Then /^the document should submit successfully$/ do
  $current_page.left_errmsg_text.should include 'Document was successfully submitted.'
end

Then /^the document should save successfully$/ do
  $current_page.left_errmsg_text.should include 'Document was successfully saved.'
  $current_page.document_status.should == 'SAVED'
end

Then /^I should get these error messages:$/ do |error_msgs|
  $current_page.errors.should include *(error_msgs.raw.flatten)
end

