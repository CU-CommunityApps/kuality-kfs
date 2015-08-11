And /^I open the document with ID (\d+)$/ do |document_id|
  visit(MainPage).doc_search
  sleep 6
  on DocumentSearch do |search|
    search.close_parents
    search.document_type.fit ''
    search.document_id.fit   document_id
    search.search
    search.wait_for_search_results
    search.open_doc document_id
  end
end

Then /^the (.*) document goes to (PROCESSED|ENROUTE|FINAL|INITIATED|SAVED)$/ do |document, doc_status|
  # sleep 20
  document_object_for(document).view
  on page_class_for(document) do |page|
    page.document_status.should == doc_status
  end
end

Then /^the (.*) document goes to one of the following statuses:$/ do |document, required_statuses|
  # sleep 10
  document_object_for(document).view
  on(page_class_for(document)) { |page| required_statuses.raw.flatten.should include page.document_status }
end

Then /^the document status is (.*)/ do |doc_status|
  on(KFSBasePage) { $current_page.document_status.should == doc_status }
end

And /^I remember the (.*) document number$/ do |document|
  @remembered_document_id = on(page_class_for(document)).document_id
end

And /^I retain the (.*) document number from this transaction$/ do |document|
  @retained_document_id = on(page_class_for(document)).document_id
end

Then /^The value for (.*) field is "(.*)"$/ do |field_name, field_value|
  $current_page.send(StringFactory.damballa(field_name)).should==field_value
end

And /^I collapse all tabs$/ do
  on(KFSBasePage).collapse_all
end

And /^I expand all tabs$/ do
  on(KFSBasePage).expand_all
end

And /^I recall the financial document$/ do
  on(KFSBasePage).recall_current_document
  on RecallPage do |page|
    page.reason.fit 'Recall test'
    page.recall
  end
end

And /^I recall and cancel the financial document$/ do
  on(KFSBasePage).recall_current_document
  on RecallPage do |page|
    page.reason.set 'Recall and cancel test'
    page.recall_and_cancel
  end
end

When /^I view the (.*) document$/ do |document|
  document_object_for(document).view
end

When /^I display the (.*) document$/ do |document|
  document_object_for(document).view
  document_object_for(document).absorb! :new
end

And /^I calculate the (.*) document$/ do |document|
  document_object_for(document).calculate
end

##################################################################################################
# This section contains steps with the form of "I ACTION the|a|an DOCUMENT_NAME document..."
##################################################################################################
# This step performs the actual action on the document being requested by the five steps after it.
# This was done so there is a single maintenance point to deal with increasing action wait times.
# Additional logic required but not related to the button press action on the document should be
# placed in the calling step and not in this one. If the Gherkin of the calling step does not
# specify what response should be given for any questions resulting from the action, a response
# of "yes" is being presumed in the calling Gherkin and "yes" is being passed into this routine.
##################################################################################################
And /^I (#{BasePage::available_buttons}) the (.*) document answering (.*) to any questions$/ do |button, document, question_response|
  # obtain how long we should idle waiting for the action to complete, should be defined on each data object
  object_klass = object_class_for(document)
  idle_time = object_klass::DOC_INFO[:action_wait_time]

  # perform requested action
  doc_object = snake_case document
  button.gsub!(' ', '_')  #change any spaces to underscores
  get(doc_object).send(button)

  # based on action, idle for required amount of seconds, for consistency button
  # has had its spaces changed to underscores before we reach this case statement
  # so we can be assured of the format of the string we are looking for
  case button
    when 'save'
      # on(KFSBasePage).wait_for_reload_button(idle_time)
      $current_page.wait_for_reload_button(idle_time)

    when 'submit'
      # on(KFSBasePage).wait_for_sendAdHocRequest_button(idle_time)
      $current_page.wait_for_sendAdHocRequest_button(idle_time)

    when  'approve', 'blanket_approve'
      sleep idle_time   #Cannot wait_for_...these actions do not stay on current page, instead redirect back to Main Menu page
    #else #implied no additional waiting for the requested action is needed
  end #case-button

  #now deal with any confirmation pages generated ensuring references remain on the current page we are working with
  original_page = $current_page
  on(YesOrNoPage).yes_if_possible if question_response == 'yes'
  on(YesOrNoPage).no_if_possible if question_response == 'no'
  $current_page = original_page
end

And /^I (#{BasePage::available_buttons}) a[n]? (.*) document$/ do |button, document|
  doc_object = snake_case document
  object_klass = object_class_for(document)

  # # This has to do with not being on page that you want to do the action for and getting to that page
  # # Should this code be needed, just perform a visit for each app tab and not hitting the link for the doc.
  # if defined? object_klass::DOC_INFO && object_klass::DOC_INFO.transactional?
  #   visit(MainPage).send(doc_object)
  # end

  set(doc_object, (create object_klass))
  step "I #{button} the #{document} document answering yes to any questions"
end

And /^I copy a random (.*) document with (.*) status/ do |document, doc_status|
  doc_object = snake_case document
  object_klass = object_class_for(document)

  on DocumentSearch do |search|
    search.document_type.set object_klass::DOC_INFO[:type_code]
    search.search
    @document_id = search.docs_with_status(doc_status, search).sample
    search.open_doc @document_id
  end

  on page_class_for(document) do |page|
    page.copy_current_document
    @document_id = page.document_id
  end

  set(doc_object, make(object_klass, document_id: @document_id))
  step "I save the #{document} answering yes to any questions"
end

When /^I (#{BasePage::available_buttons}) the (.*) document$/ do |button, document|
  step "I #{button} the #{document} document answering yes to any questions"
end

When /^I (#{BasePage::available_buttons}) the (.*) document, confirming any questions, if it is not already FINAL/ do |button, document|
  unless on(KFSBasePage).document_status == 'FINAL'
    step "I #{button} the #{document} document answering yes to any questions"
  end
end

When /^I (#{BasePage::available_buttons}) the (.*) document and confirm any questions$/ do |button, document|
  step "I #{button} the #{document} document answering yes to any questions"
end

When /^I (#{BasePage::available_buttons}) the (.*) document and deny any questions$/ do |button, document|
  step "I #{button} the #{document} document answering no to any question"
end
############End-of section contains steps with the form of "I ACTION the|a|an DOCUMENT_NAME document..."##############
