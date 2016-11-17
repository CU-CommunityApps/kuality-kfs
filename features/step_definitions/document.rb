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
  document_object_for(document).view
  on page_class_for(document) do |page|
    page.document_status.should == doc_status
  end
end

Then /^the (.*) document goes to one of the following statuses:$/ do |document, required_statuses|
  document_object_for(document).view
  on(page_class_for(document)) { |page| required_statuses.raw.flatten.should include page.document_status }
end

Then /^the document status is (.*)/ do |doc_status|
  on(KFSBasePage) { $current_page.document_status.should == doc_status }
end

And /^I remember the (.*) document number$/ do |document|
  @remembered_document_id = on(page_class_for(document)).document_id
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

  doc_object = snake_case document
  button.gsub!(' ', '_')
  get(doc_object).send(button)

  # Based on action, idle for required amount of seconds.
  # For consistency, button has had its spaces changed to underscores before we reach this case statement
  # so we can be assured of the format of the string we are looking for.
  unless (object_klass::DOC_INFO[:label]).eql?('Asset Manual Payment')
    case button
      when 'save'
        $current_page.wait_for_reload_button(idle_time)

      when 'submit'
        $current_page.wait_for_sendAdHocRequest_button(idle_time)

      when  'approve', 'blanket_approve'
        # These actions do not stay on current page so cannot wait for a widget on the the current page.
        # Instead redirect back to Main Menu page after waiting
        sleep idle_time
    end
  end

  # Now deal with any yes/no confirmation pages generated ensuring final reference when we are done
  # remains on current page we are working with prior to dealing with confirmations.
  # Additional idle time needed when business rules generate confiramtion pages because actual page
  # processing does not occur until after the confirmation.
  original_page = $current_page
  on(YesOrNoPage) do |confirm_page|
    if question_response == 'yes'
      confirm_page.yes_if_possible
      sleep idle_time
    end
    if question_response == 'no'
      confirm_page.no_if_possible
      sleep idle_time
    end
  end

  # Specific edocs generate yes/no pages whose processing actually occurs after the yes or no button is pressed,
  # not when the action button is pressed. Need additional wait time JUST for those edocs and we will do a sleep
  case object_klass::DOC_INFO[:label]
    when 'Asset Manual Payment'
      sleep idle_time
  end
  $current_page = original_page
end

And /^I (#{BasePage::available_buttons}) a[n]? (.*) document$/ do |button, document|
  doc_object = snake_case document
  object_klass = object_class_for(document)

  set(doc_object, (create object_klass))
  step "I #{button} the #{document} document answering yes to any questions"
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
############End-of section contains steps with the form of "I ACTION the|a|an DOCUMENT_NAME document..."##############
