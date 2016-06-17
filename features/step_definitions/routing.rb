include Utilities

And /^the next pending action for the (.*) document is an? (.*) from a (.*)$/ do |document, action, user_type|

  on page_class_for(document) do |page|
    page.show_route_log_button.wait_until_present
    page.show_route_log unless page.route_log_shown?

    page.pnd_act_req_table_action.visible?.should

    if page.pnd_act_req_table_requested_of.text.match(/Multiple/m)
      page.show_pending_action_requests_in_action_list if page.pending_action_requests_in_action_list_hidden?

      page.pnd_act_req_table_multi.visible?.should
      page.pnd_act_req_table_multi_action.text.should match(/#{action}/)
      page.pnd_act_req_table_multi_annotation.text.should match(/#{user_type}/)
    else
      page.pnd_act_req_table_action.text.should match(/#{action}/)
      page.pnd_act_req_table_annotation.text.should match(/#{user_type}/)
    end
  end
end

When /^I route the (.*) document to final$/ do |document|
  step "I view the #{document} document"
  until 'FINALPROCESSSED'.include? on(page_class_for(document)).document_status
    step "I switch to the user with the next Pending Action in the Route Log for the #{document} document"
    step "I view the #{document} document"
    step "I attach an Invoice Image to the #{document} document" if document == 'Payment Request' &&
                                                                    (document_object_for(document).notes_and_attachments_tab.length.zero? ||
                                                                     document_object_for(document).notes_and_attachments_tab.index{ |na| na.type == 'Invoice Image' }.nil?)
    step "I approve the #{document} document, confirming any questions, if it is not already FINAL"
    step "I view the #{document} document"
  end

end


Then  /^the (.*) document routes to the (.*) node$/ do |document, node|
  sleep(120)  #need to wait 2 minutes for cynergy to do its thing before verifying document routed correctly
  pending_action_request_node = ''
  step "the #{document} document goes to ENROUTE"
  on page_class_for(document) do |page|
    page.show_route_log_button.wait_until_present
    page.show_route_log unless page.route_log_shown?
    page.pnd_act_req_table_action.visible?.should
    page.show_pending_action_requests_in_action_list unless page.pending_action_requests_in_action_list_shown?

    until (page.pen_act_req_table_sub_node == node) || ('FINALPROCESSSED'.include? on(page_class_for(document)).document_status)
      step "I route the #{document} document to the next node"
      page.show_route_log_button.wait_until_present
      page.show_route_log unless page.route_log_shown?
      page.pnd_act_req_table_action.visible?.should
      page.show_pending_action_requests_in_action_list unless page.pending_action_requests_in_action_list_shown?
      pending_action_request_node = page.pen_act_req_table_sub_node
    end #until
  end #on page
  pending_action_request_node.should == node
end


When /^I route the (.*) document to the next node$/ do |document|
  step "I view the #{document} document"
  step "I switch to the user with the next Pending Action in the Route Log for the #{document} document"
  step "I view the #{document} document"
  step "I attach an Invoice Image to the #{document} document" if document == 'Payment Request' &&
      (document_object_for(document).notes_and_attachments_tab.length.zero? ||
          document_object_for(document).notes_and_attachments_tab.index{ |na| na.type == 'Invoice Image' }.nil?)
  step "I approve the #{document} document, confirming any questions, if it is not already FINAL"
  step "I view the #{document} document"
end


Then /^I switch to the user with the next Pending Action in the Route Log for the (.*) document$/ do |document|
  new_user = ''
  on page_class_for(document) do |page|
    page.expand_all
    page.show_route_log unless page.route_log_shown?

    page.pnd_act_req_table_action.visible?.should

    if page.pnd_act_req_table_requested_of.text.match(/Multiple/m)
      page.show_pending_action_requests_in_action_list if page.pending_action_requests_in_action_list_hidden?

      page.pnd_act_req_table_multi_requested_of.links.first.click
    else
      #page.pnd_act_req_table_requested_of.links.first.click
      page.first_pending_approve
    end

    page.use_new_tab

    # TODO: Actually build a functioning PersonPage to grab this. It seems our current PersonPage ain't right.
    if page.frm.div(id: 'tab-Overview-div').exists?
      # WITH FRAME
      page.frm.div(id: 'tab-Overview-div').tables[0][1].tds.first.should exist
      page.frm.div(id: 'tab-Overview-div').tables[0][1].tds.first.text.empty?.should_not

      if page.frm.div(id: 'tab-Overview-div').tables[0][1].text.include?('Principal Name:')
        new_user = page.frm.div(id: 'tab-Overview-div').tables[0][1].tds.first.text
      else
        # TODO : this is for group.  any other alternative ?
        mbr_tr = page.frm.select(id: 'document.members[0].memberTypeCode').parent.parent.parent
        new_user = mbr_tr[4].text
      end

    elsif page.div(id: 'tab-Overview-div').exists?
      #NO FRAME
      page.div(id: 'tab-Overview-div').tables[0][1].tds.first.should exist
      page.div(id: 'tab-Overview-div').tables[0][1].tds.first.text.empty?.should_not

      if page.div(id: 'tab-Overview-div').tables[0][1].text.include?('Principal Name:')
        new_user = page.div(id: 'tab-Overview-div').tables[0][1].tds.first.text
      else
        # TODO : this is for group.  any other alternative ?
        mbr_tr = page.select(id: 'document.members[0].memberTypeCode').parent.parent.parent
        new_user = mbr_tr[4].text
      end
    end

  page.close_children
  end

  @new_approver = new_user
  step "I am logged in as \"#{new_user}\""
end

And /^the initiator is not an approver in the Future Actions table$/ do
  on KFSBasePage do |page|
    page.expand_all
    page.show_future_action_requests if page.show_future_action_requests_button.exists?
    page.future_actions_table.rows(text: /APPROVE/m).any? { |r| r.text.include? 'Initiator' }.should_not
  end
end

And /^I verify that the following (Pending|Future) Action approvals are requested:$/ do |action_type, roles|
  roles = roles.raw.flatten
  on KFSBasePage do |page|
    page.expand_all
    case action_type
      when 'Pending'
        roles.each do |ra|
          page.pnd_act_req_table.rows(text: /APPROVE/m).any? { |r| r.text.include? ra }.should
        end
      when 'Future'
        page.show_future_action_requests if page.show_future_action_requests_button.exists?
        roles.each do |ra|
          page.future_actions_table.rows(text: /APPROVE/m).any? { |r| r.text.include? ra }.should
        end
    end
  end

end

And /^the POA Routes to the FO$/ do
  @fo_users.length.should >= 1
end


And /^the (.*) document does not route to the Financial Officer$/ do  |document|
  on(page_class_for(document)).app_doc_status.should_not include 'Fiscal Officer'
end


And /^the (.*) document's route log is:$/ do |document, desired_route_log|
  # desired_route_log.hashes.keys => [:Role, :Action]

  on page_class_for(document) do |page|
    page.show_route_log_button.wait_until_present
    page.show_route_log unless page.route_log_shown?

    page.show_pending_action_requests unless page.pending_action_requests_shown?
    page.pnd_act_req_table_action.visible?.should

    page.show_future_action_requests unless page.future_action_requests_shown?
    page.future_actions_table.visible?.should


    # Note: This expects you to list out the full log from start to some end point.
    #       You cannot skip any interim entries, though you could probably skip
    #       entries at the end of the list.
    route_log = page.route_log_hash
    desired_route_log.hashes.each_with_index do |row, i|
      route_log[:annotation][i].should match /#{row[:Role]}/
      route_log[:action][i].should match /#{row[:Action]}/
    end

  end
end

Then /^(.*) should be in the (.*) document Actions Taken$/ do |action, document|
  on page_class_for(document) do |page|
    page.show_route_log_button.wait_until_present
    page.show_route_log unless page.route_log_shown?

    page.show_actions_taken unless page.actions_taken_shown?
    page.actions_taken_table_action.visible?.should

    page.show_actions_taken_approved unless page.actions_taken_approved_shown?
    (page.actions_taken_table_all_actions.include? action).should == true
  end
end


Then /^the (.*) document should route to Groups (.*) with Group IDs (.*)$/ do |document, groups, ids|
  # Get route log data from the edoc
  route_log = Hash.new
  on page_class_for(document) do |page|
    page.show_route_log_button.wait_until_present
    page.show_route_log unless page.route_log_shown?

    page.show_pending_action_requests unless page.pending_action_requests_shown?
    page.pnd_act_req_table_action.visible?.should

    page.show_future_action_requests unless page.future_action_requests_shown?
    page.future_actions_table.visible?.should

    route_log = page.route_log_hash
  end

  # Get users represented as a single string in route log into an array
  route_log_requested_of = route_log[:requested_of]
  requested_users_from_route_log = Array.new
  for i in 0..(route_log_requested_of.length - 1)
    all_users_for_action = route_log_requested_of[i].split("\n")
    for j in 0..(all_users_for_action.length - 1)
      element = all_users_for_action[j]
      element = element.lstrip
      element = element.rstrip
      all_users_for_action[j] = element
    end
    requested_users_from_route_log.push(all_users_for_action)
  end

  # Get all users who should be in the specified group(s)
  group_ids = ids.split ','
  found_all_users_for_each_group = Hash.new
  group_ids.each do |group_id|
    found_all_users_for_each_group.store(group_id, false)
  end

  # Now for each group identified, determine all individuals were listed in route log for that action.
  # When multiple names exist for a group and/or route node, the order of names may not match so
  # we must ensure the lists just contain the same data elements.
  principal_names_in_group = Array.new
  last_first_names_for_group_id = Array.new
  group_ids.each do |group_id|
    principal_names_in_group = get_principal_name_for_group group_id

    principal_names_in_group.each do |principal_name|
      visit(AdministrationPage).person
      on (PersonLookup) do |person_search|
        person_search.principal_name.fit principal_name
        person_search.search
        person_search.wait_for_search_results
        last_name_first_name = person_search.returned_full_names[0]
        last_first_names_for_group_id.push(last_name_first_name)
      end
    end

    group_found_in_route_log = false
    for i in 0..(requested_users_from_route_log.length - 1)
      if last_first_names_for_group_id.length == requested_users_from_route_log[i].length
        all_must_match = requested_users_from_route_log[i].length
        requested_users_from_route_log[i].each do |user_in_route_log|
          if last_first_names_for_group_id.include? user_in_route_log
            all_must_match -= 1
          end
        end
        if all_must_match == 0
          group_found_in_route_log = true
          break
        end
      end
    end
    found_all_users_for_each_group[group_id] = group_found_in_route_log
  end #for each group_id

  # Now verify we found all individuals associate to each group specified listed together on the route log node of the document.
  group_ids.each do |group_id|
    (found_all_users_for_each_group[group_id]).should be true
  end
end
