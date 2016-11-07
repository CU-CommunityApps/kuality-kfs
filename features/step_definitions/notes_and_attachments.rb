And /^I manually add a file attachment to the Notes and Attachment Tab of the (.*) document$/ do |document|
  pending 'Not ready for primetime!'
  filename = 'vendor_attachment_test.png'
  on(page_class_for(document)).attach_notes_file.set($file_folder+filename)
  on(page_class_for(document)).attach_notes_file.value.should == filename
  pending
  @browser.send_keys :tab
  on(page_class_for(document)).attach_notes_file.value.should == filename
  pending
end

When /^I attach a file to the Notes and Attachments Tab line of the (.*) document$/ do |document|
  document_object_for(document).notes_and_attachments_tab
                               .first
                               .attach_file 'vendor_attachment_test.png'
end
