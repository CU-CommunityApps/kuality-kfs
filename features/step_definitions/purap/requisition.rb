# And /^I create an empty Requisition document$/  do
#   @requisition = create RequisitionObject
# end
#
# And /^I create the Requisition document with:$/  do |table|
#   updates = table.rows_hash
#
#   @requisition = create RequisitionObject,
#                         payment_request_positive_approval_required: updates['payment request'],
#                         vendor_number:    updates['Vendor Number'],
#                         initial_item_lines: [{
#                                                  quantity:       updates['Item Quantity'],
#                                                  unit_cost:      updates['Item Cost'],
#                                                  commodity_code: updates['Item Commodity Code'],
#                                                  catalog_number: updates['Item Catalog Number'],
#                                                  description:    updates['Item Description'].nil? ? random_alphanums(15, 'AFT') : updates['Item Description'],
#                                                  initial_accounting_lines: [{
#                                                                                 account_number: updates['Account Number'],
#                                                                                 object_code:    updates['Object Code'],
#                                                                                 percent:        updates['Percent']
#                                                                             }]
#                                              }]
# end
#
# And /^I add an item to the Requisition document with:$/ do |table|
#   add_item = table.rows_hash
#
#   @requisition.add_item_line({
#                                  quantity:  add_item['Item Quantity'],
#                                  unit_cost: add_item['Item Cost'],
#                                  commodity_code: add_item['Item Commodity Code'],
#                                  catalog_number: add_item['Item Catalog Number'],
#                                  uom: add_item['Item Unit of Measure'],
#                                  description: (add_item['Item Description'].nil? ? random_alphanums(15, 'AFT') : add_item['Item Description']),
#                                  initial_accounting_lines: [{
#                                                                 account_number: add_item['Account Number'],
#                                                                 object_code:    add_item['Object Code'],
#                                                                 percent:        add_item['Percent']
#                                                             }]
#                              })
# end
#
# And /^the Requisition status is '(.*)'$/ do |req_status|
#   on(RequisitionPage).requisition_status.should include req_status
# end
#
# And /^I view the (.*) document on my action list$/ do |document|
#   visit(MainPage).action_list
#   sleep 3
#   on ActionList do |page|
#     page.close_parents
#     #sort the date
#     # if previous user already clicked this sort, then action list for next user will be sorted with 'Date created'.  So, add this 'unless' check
#     page.sort_results_by('Date Created') unless page.result_item(document_object_for(document).document_id).exists?
#
#     page.result_item(document_object_for(document).document_id).wait_until_present
#     page.open_item(document_object_for(document).document_id)
#   end
#   if document.eql?('Requisition')
#     on RequisitionPage do |page|
#       @requisition.requisition_id = page.requisition_id
#       @requisition_initiator = page.initiator # FIXME: Retrofit anything using this to use @requisition.initiator
#     end
#   end
#
# end
#
# And /^I view the Requisition document from the Requisitions search$/ do
#   visit(MainPage).requisitions
#   on DocumentSearch do |page|
#     page.document_id_field.fit @requisition.document_id
#     page.requisition_num.fit @requisition.requisition_id unless @requisition.requisition_id.nil?
#     page.search
#     page.open_item(@requisition.document_id)
#   end
#   on(RequisitionPage).expand_all
#
# end
#
# And /^I (submit|close|cancel) a Contract Manager Assignment of '(\d+)' for the Requisition$/ do |btn, contract_manager_number|
#   visit(MainPage).contract_manager_assignment
#   on ContractManagerAssignmentPage do |page|
#     page.set_contract_manager(@requisition.requisition_id, contract_manager_number)
#     page.send(btn)
#   end
#   sleep 5
# end
#
# And /^I retrieve the Requisition document$/ do
#   visit(MainPage).requisitions  #remember "S" is for search
#   on DocumentSearch do |page|
#     page.document_type.set 'REQS'
#     page.requisition_num.fit @requisition.requisition_id
#     page.search
#     page.open_item(@requisition.document_id)
#   end
# end
#
#
# And /^the View Related Documents Tab PO Status displays$/ do
#   on RequisitionPage do |page|
#     page.show_related_documents
#     page.show_purchase_order
#     # verify unmasked and 'UNAPPROVED'
#     page.purchase_order_number.should_not include '*****' # unmasked
#     if !@auto_gen_po.nil? && !@auto_gen_po
#       page.po_unapprove.should include 'UNAPPROVED'
#     end
#     page.purchase_order_number_link
#
#   end
#   sleep 10
#   on PurchaseOrderPage do |page|
#     page.po_doc_status.should_not match(/Error occurred sending cxml/m),
#                                   "There was an error sending the Purchase Order to SciQuest. Please check the notes on Purchase Order ##{page.purchase_order_number}"
#     @purchase_order = make PurchaseOrderObject, purchase_order_number: page.purchase_order_number,
#                            document_id:           page.document_id,
#                            initial_item_lines:    [] # FIXME: This should really use #absorb! to pull in existing data
#   end
# end
#
# And /^the Purchase Order Number is unmasked$/ do
#   on(PurchaseOrderPage).po_number.should_not include '****'
# end
#
# And /^I Complete Selecting Vendor (.*)$/ do |vendor_number|
#   on(PurchaseOrderPage).vendor_search
#   on VendorLookupPage do |vlookup|
#     vlookup.vendor_number.fit vendor_number
#     vlookup.search
#     vlookup.return_value(vendor_number)
#   end
# end
#
# And /^I enter a Vendor Choice$/ do
#   on(PurchaseOrderPage).vendor_choice.fit 'Lowest Price'
# end
#
# And /^I calculate and verify the GLPE with amount (.*)$/ do |amount|
#   on PurchaseOrderPage do |page|
#     page.expand_all
#     page.calculate
#   end
#   # TODO : not sure what to verify about GLPE
#   on (GeneralLedgerPendingEntryTab) do |gtab|
#     idx = gtab.glpe_tables.length - 1
#     glpe_table = gtab.glpe_tables[idx]
#     glpe_table[1][11].text.should include amount
#     glpe_table[2][11].text.should include amount
#     if glpe_table[1][12].text.eql?('D')
#       glpe_table[2][12].text.should == 'C'
#     else
#       if glpe_table[1][12].text.eql?('C')
#         glpe_table[2][12].text.should == 'D'
#       end
#     end
#   end
# end
#
# And /^the (.*) Doc Status is (.*)/ do |document, doc_status|
#   on(KFSBasePage).app_doc_status.should == doc_status
# end
#
# And /^I Complete Selecting a Vendor (.*)$/ do |vendor_number|
#   on(PurchaseOrderPage).vendor_search
#   on VendorLookupPage do |vlookup|
#     vlookup.vendor_number.fit vendor_number
#     vlookup.search
#     vlookup.return_value(vendor_number)
#   end
# end
#
# And /^I enter a Vendor Choice of '(.*)'$/ do  |choice|
#   on(PurchaseOrderPage).vendor_choice.fit choice
# end
#
# And /^I calculate and verify the GLPE tab$/ do
#   on PurchaseOrderPage do |page|
#     page.calculate
#     page.show_glpe
#
#     page.glpe_results_table.text.include? @requisition.items.first.accounting_lines.first.object_code
#     page.glpe_results_table.text.include? @requisition.items.first.accounting_lines.first.account_number
#     # credit object code should be 3110 (depends on parm)
#
#   end
# end
#
# And /^the Purchase Order document status is '(.*)'$/  do  |status|
#   on PurchaseOrderPage do |page|
#     sleep 5
#     page.reload unless status == 'CANCELED'
#     page.document_status.should == status
#   end
# end
#
# And /^the Purchase Order Doc Status equals '(.*)'$/ do |po_doc_status|
#   #this is a different field from the document status field
#   on(PurchaseOrderPage).po_doc_status.should == po_doc_status
# end
#
# And /^The Requisition status is '(.*)'$/ do |doc_status|
#   on RequisitionPage do |page|
#     sleep 5
#     page.reload unless page.reload_button.nil?
#     page.document_status == doc_status
#   end
# end
#
# And /^I select the purchase order '(\d+)' with the doc id '(\d+)'$/ do |req_num, doc_id|
#   on DocumentSearch do |page|
#     page.requisition_number.set req_num.to_s
#     page.search
#     page.result_item(doc_id.to_s).when_present.click
#     sleep 5
#   end
# end
#
# And /^I fill out the PREQ initiation page and continue$/ do
#   @payment_request = create PaymentRequestObject, purchase_order_number: @purchase_order.purchase_order_number,
#                             invoice_date:          yesterday[:date_w_slashes],
#                             invoice_number:        rand(100000),
#                             vendor_invoice_amount: @requisition.items.first.quantity.to_f * @requisition.items.first.unit_cost.to_i
# end
#
# And /^I change the Remit To Address$/ do
#   @payment_request.edit vendor_address_1: "#{on(PaymentRequestPage).vendor_address_1.value}, Apt1" # FIXME: Once PaymentRequestObject#absorb! is implemented
# end
#
# And /^I enter the Qty Invoiced and calculate$/ do
#   @preq_id = on(PaymentRequestPage).preq_id # FIXME: Steps that need this variable should use @payment_request.number instead! If there are none, this line can be removed.
#   @payment_request.items.first.edit quantity: @requisition.items.first.quantity
#   @payment_request.items.first.calculate
# end
#
# And  /^I enter a Pay Date$/ do
#   @payment_request.edit pay_date: right_now[:date_w_slashes]
# end
#
# And /^I attach an Invoice Image to the (.*) document$/ do |document|
#   document_object_for(document).notes_and_attachments_tab
#   .add note_text:      'Testing note text.',
#        file:           'vendor_attachment_test.png',
#        type:           'Invoice Image'
# end
#
# And /^I view the Purchase Order document via e-SHOP$/ do
#   @purchase_order.view_via 'e-SHOP'
# end
#
# And /^the Document Status displayed '(\w+)'$/ do |doc_status|
#   on(EShopAdvancedDocSearchPage).return_po_value @purchase_order.purchase_order_number
#   on EShopSummaryPage do |page|
#     page.results_column.text.should_not include 'No Documents found' if page.results_column.present?
#     page.doc_summary[1].text.should include "Workflow  #{doc_status}"
#   end
# end
#
# And /^the Delivery Instructions displayed equals what came from the PO$/ do
#   on EShopSummaryPage do |page|
#     page.doc_po_link
#     page.doc_summary[1].text.should match /Note to Supplier.*#{@requisition.vendor_notes}/m
#     page.doc_summary[3].text.should match /Delivery Instructions.*#{@requisition.delivery_instructions}/m
#   end
# end
#
# And /^the Attachments for Supplier came from the PO$/ do
#   on EShopSummaryPage do |page|
#     page.attachments_link
#     page.search_results.should exist
#     # Longer file names are cut and an ellipse is added to the end, so we need to restrict the length of the match
#     page.search_results[1].text[0..16].should == @requisition.notes_and_attachments_tab.first.file[0..16]
#   end
# end
#
# And  /^I select the Payment Request Positive Approval Required$/ do
#   on(RequisitionPage).payment_request_positive_approval_required.set
# end
#
# And /^I verified the GLPE on Payment Request page with the following:$/ do |table|
#   on(PaymentRequestPage).expand_all
#   glpe_entry = table.raw.flatten.each_slice(7).to_a
#   glpe_entry.shift # skip header row
#   glpe_entry.each do |line,account_number,object_code,balance_type,object_type,amount,dorc|
#     on GeneralLedgerPendingEntryTab do |gtab|
#       idx = gtab.glpe_tables.length - 1
#       glpe_table = gtab.glpe_tables[idx]
#       seq = line.to_i
#       glpe_table[seq][3].text.should == account_number
#       glpe_table[seq][5].text.should == object_code
#       glpe_table[seq][9].text.should == balance_type
#       glpe_table[seq][10].text.should == object_type
#       glpe_table[seq][11].text.should == amount
#       glpe_table[seq][12].text.strip.should == dorc
#     end
#   end
# end
#
# And /^I enter Delivery Instructions and Notes to Vendor$/ do
#   @requisition.edit vendor_notes:          random_alphanums(40, 'AFT-ToVendorNote'),
#                     delivery_instructions: random_alphanums(40, 'AFT-DelvInst')
# end
#
# When /^I visit the "(.*)" page$/  do   |go_to_page|
#   on(MainPage).send(go_to_page.downcase.gsub(' ', '_').gsub('-', '_'))
# end
#
# And /^I enter Payment Information for recurring payment type (.*)$/ do |recurring_payment_type|
#   unless recurring_payment_type.empty?
#     on RequisitionPage do |page|
#       page.recurring_payment_type.fit recurring_payment_type
#       page.payment_from_date.fit      right_now[:date_w_slashes]
#       page.payment_to_date.fit        next_year[:date_w_slashes]
#     end
#   end
# end
#
# Then /^the Payment Request document's GLPE tab shows the Requisition document submissions$/ do
#   on PaymentRequestPage do |page|
#     page.show_glpe
#
#     @requisition.items.should have_at_least(1).items, 'Not sure if the Requisition document had Items!'
#     @requisition.items.first.accounting_lines.should have_at_least(1).accounting_lines, 'Not sure if the Requisition\'s Item had accounting lines!'
#     page.glpe_results_table.text.should include @requisition.items.first.accounting_lines.first.object_code
#     page.glpe_results_table.text.should include @requisition.items.first.accounting_lines.first.account_number
#   end
# end
#
# Then /^I switch to the user with the next Pending Action in the Route Log to approve (.*) document to Final$/ do |document|
#   # TODO : Should we collect the app doc status to make sure that this process did go thru all the route nodes ?
#   x = 0 # in case something wrong , limit to 10
#   @base_org_review_level = 0
#   @org_review_users = Array.new
#   @commodity_review_users = Array.new
#   @fo_users = Array.new
#   while true && x < 10
#     new_user = ''
#     on(page_class_for(document)) do |page|
#       page.expand_all
#       if (page.document_status != 'FINAL')
#         (0..page.pnd_act_req_table.rows.length - 3).each do |i|
#           idx = i + 1
#           if page.pnd_act_req_table[idx][1].text.include?('APPROVE')
#             if (!page.pnd_act_req_table[idx][2].text.include?('Multiple'))
#               page.pnd_act_req_table[idx][2].links[0].click
#               page.use_new_tab
#               new_user = page.new_user
#             else
#               # for Multiple
#               page.show_multiple
#               page.multiple_link_first_approver
#               page.use_new_tab
#               new_user = page.new_user
#             end
#             page.close_children
#             break
#           end
#         end
#       else
#         break
#       end
#     end
#
#     if new_user != ''
#       step "I am logged in as \"#{new_user}\""
#       step "I view the #{document} document on my action list"
#       if (document == 'Payment Request')
#         if (on(page_class_for(document)).app_doc_status == 'Awaiting Tax Approval')
#           step  "I update the Tax Tab"
#           step  "I calculate the Payment Request document"
#         else
#           if (on(page_class_for(document)).app_doc_status == 'Awaiting Treasury Manager Approval')
#             #TODO : wait till Alternate PM is implemented
#           end
#         end
#       end
#       if (on(page_class_for(document)).app_doc_status == 'Awaiting Base Org Review' || on(page_class_for(document)).app_doc_status == 'Awaiting Chart Approval')
#         @base_org_review_level += 1
#         @org_review_users.push(new_user)
#       else
#         if (on(page_class_for(document)).app_doc_status == 'Awaiting Commodity Review' || on(page_class_for(document)).app_doc_status == 'Awaiting Commodity Code Approval')
#           @commodity_review_users.push(new_user)
#         else
#           if (on(page_class_for(document)).app_doc_status == 'Awaiting Fiscal Officer')
#             @fo_users.push(new_user)
#           end
#         end
#       end
#       step "I approve the #{document} document"
#       step "the #{document} document goes to one of the following statuses:", table(%{
#         | ENROUTE   |
#         | FINAL     |
#       })
#     end
#
#     if on(page_class_for(document)).document_status == 'FINAL'
#       break
#     end
#     x += 1
#   end
#
#   if @org_review_routing_check
#     step "the #{document} document routes to the correct individuals based on the org review levels"
#   else
#     if @commodity_review_routing_check
#       step "I validate Commodity Review Routing for #{document} document"
#     end
#   end
# end
#
# And /^During Approval of the (.*) document the Financial Officer adds a second line item with:$/ do |document, table|
#   pending 'This step is so very very wrong.'
#   step "I view the Requisition document from the Requisitions search"
#   step 'I switch to the user with the next Pending Action in the Route Log for the Requisition document'
#   step "I view the Requisition document on my action list"
#   on RequisitionPage do |page|
#     page.expand_all
#     accounting_line_info = table.rows_hash
#
#     doc_object = snake_case document
#
#     on page_class_for(document) do |page|
#       page.added_percent.fit '50'
#
#       AccountingLinesMixin.add_source_line({
#                                                account_number: accounting_line_info['Number'],
#                                                object:         accounting_line_info['Object Code'],
#                                                percent:         accounting_line_info['Percent']
#                                            })
#
#       page.calculate
#       sleep 2
#       page.approve
#     end
#   end
# end
#
# And /^I open the Purchase Order Amendment on the Requisition document$/ do
#   step 'I view the Requisition document'
#   on RequisitionPage do |page|
#     page.expand_all
#     @purchase_order_amendment_id = page.purchase_order_amendment_value
#     page.purchase_order_amendment
#   end
# end
#
# And /^I (submit|close|cancel) a Contract Manager Assignment for the Requisition$/ do |btn|
#   visit(MainPage).contract_manager_assignment
#   on ContractManagerAssignmentPage do |page|
#     page.contract_manager_table.rows.each_with_index do |row, index|
#       if row.a(text: @requisition_id).exists?
#         page.search_contract_manager_links[index-1].click
#         break
#       end
#     end
#   end
#   on (ContractManagerLookupPage) do |page|
#     page.search
#     # click twice to have the highest dollar limit at top
#     page.sort_results_by('Contract Manager Delegation Dollar Limit')
#     page.sort_results_by('Contract Manager Delegation Dollar Limit')
#     page.return_value_links.first.click
#   end
#   on(ContractManagerAssignmentPage).send(btn)
# end
#
# And /^I create the Requisition document with following specifications:$/ do |table|
#   arguments = table.rows_hash
#   #TODO : Parameter name being dynamically created and KFS-AFTEST parameter may not exist in the KFS system. FIX!
#   vendor_number = get_aft_parameter_value('REQS_' + (arguments['Vendor Type'].nil? ? 'NONB2B' : arguments['Vendor Type'].upcase) + '_VENDOR')
#   account_number = get_account_of_type(arguments['Account Type'])
#   commodity_code = get_commodity_of_type(arguments['Commodity Code'])
#   object_code = get_object_code_of_type(arguments['Object Code'])
#   item_qty = 1
#
#   apo_amount = get_parameter_values('KFS-PURAP', 'AUTOMATIC_PURCHASE_ORDER_DEFAULT_LIMIT_AMOUNT', 'Requisition')[0].to_i
#   amount = arguments['Amount']
#   if amount.nil? || amount == 'LT APO'
#     item_qty = apo_amount/1000 - 1
#   else
#     if amount == 'GT APO'
#       item_qty = apo_amount/1000 + 1
#     else
#       item_qty = amount.to_i/1000
#     end
#   end
#
#   step 'I create the Requisition document with:',
#        table(%Q{
#          | Vendor Number       | #{vendor_number}  |
#          | Item Quantity       | #{item_qty}        |
#          | Item Cost           | 1000               |
#          | Item Commodity Code | #{commodity_code}  |
#          | Account Number      | #{account_number}  |
#          | Object Code         | #{object_code}     |
#          | Percent             | 100                |
#        })
#
# end
#
# And /^I change the item type to (Qty|No Qty) on Item Tab$/ do |item_type|
#   case item_type
#     when 'No Qty'
#       unit_price = @requisition.items.first.quantity.to_f * @requisition.items.first.unit_cost.to_f
#       @requisition.items.first.edit type: 'No Qty', quantity: '', uom: '', unit_cost: unit_price
#   end
#
# end
#
# And /^I add a random delivery address to the Requisition document if there is not one present$/ do
#   @requisition.add_random_building_address
# end
#
# And /^I add a random phone number to the Requestor Phone on the Requisition document$/ do
#   on(RequisitionPage).requestor_phone.fit random_phone_number
# end

And /^I create a Requisition with required Chart-Organization, Delivery and Additional Institutional information populated$/ do
  visit(MainPage).requisition
  on RequisitionPage do |req_page|
    # Check Chart/Org associated with the user; if either one does not exist, use corresponding parameter default value and perform lookup
    # Ensure both values are stripped or empty strings
    chart,org = req_page.chart_org_readonly.split('/')
    chart = chart.nil? ? '' : chart.strip
    org = org.nil? ? '' : org.strip
    if org.empty? || chart.empty?
      # Substitute default parameters for empty values then perform lookup
      req_page.chart_org_search
      on OrganizationLookupPage do |org_lookup|
        chart = get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE) if chart.empty?
        org = get_aft_parameter_value(ParameterConstants::DEFAULT_ORGANIZATION_CODE) if org.empty?
        org_lookup.chart_code.set chart
        org_lookup.organization_code.set org
        org_lookup.search
        org_lookup.wait_for_search_results
        org_lookup.return_random
      end
    end

    # Check read-only address line one value; if it does not exist, look-up a building
    if req_page.delivery_address_1_readonly.empty?
      # try a set number of times to find a building with a zip code present
      max_num_searches = 5
      number_bldg_search_attempts = 0
      while req_page.delivery_postal_code_readonly.empty? && number_bldg_search_attempts < max_num_searches
        req_page.building_search
        on BuildingLookupPage do |bldg_page|
          bldg_page.search
          bldg_page.wait_for_search_results
          bldg_page.return_random
        end
        number_bldg_search_attempts +=1
      end #while-postal code blank
      fail ArgumentError, "Attempted #{max_num_searches} times to find Delivery Building with valid Postal Code but each time Postal Code was blank." if number_bldg_search_attempts == max_num_searches
    end

    # look-up and populate room for building just selected
    req_page.room_search
    on(RoomLookupPage).search_and_return_random

    # ensure required email addresses have data values
    req_page.delivery_email.set random_email_address if req_page.delivery_email_new.empty? || req_page.delivery_email_new == 'null'
    req_page.requestor_email.set random_email_address if req_page.requestor_email_new.empty? || req_page.requestor_email_new == 'null'

    # ensure required phone numbers have data values
    req_page.delivery_phone_number.set random_phone_number if req_page.delivery_phone_number_new.empty? || req_page.delivery_phone_number_new == 'null'
    req_page.requestor_phone.set random_phone_number if req_page.requestor_phone_new.empty? || req_page.requestor_phone_new == 'null'

    @requisition = make RequisitionObject
    req_page.description.fit @requisition.description # This will be auto-generated in the object, but not auto-populated on the page
    @requisition.absorb! :new
  end
end


And /^I add an Item with a unit cost of (.*) to the Requisition with a (sensitive|non\-sensitive) Commodity Code$/ do |unit_cost, commodity_code_type|
  # Use the object's default AFT parameters and methods on the ItemLineObject to fill out the data elements in the page
  @item = make ItemLineObject

  on ItemsTab do |item_tab|
    item_tab.commodity_code_search
    on CommodityCodeLookupPage do |comm_page|
      comm_page.sensitive_data.select_value(@item.determine_commodity_code_of_type(commodity_code_type))
      comm_page.search
      comm_page.wait_for_search_results
      begin
        comm_page.return_random
          # first time cache building causes this, wait a bit longer and try again
      rescue Watir::Exception::UnknownObjectException
        puts "Watir::Exception::UnknownObjectException rescued for Commmodity Code search. Waiting a bit longer for search results before attempting return_random a second time."
        sleep(30)
        comm_page.return_random
      end

    end
    #Leave Item Type at page default value; otherwise use the object's default values
    item_tab.quantity.set        @item.quantity
    item_tab.unit_of_measure.set @item.uom
    item_tab.description.set     @item.description
    item_tab.unit_cost.set       unit_cost
    item_tab.add_item
  end
  @requisition.items.update_from_page! :new
end


And /^I add an Accounting Line to or update the favorite account specified for the Requisition Item just created$/ do
  # NOTE: Need to determine whether user has favorite account that could have already pre-populated
  #       the accounting lines. Take the action of overwriting that favorite account with a known
  #       good account because favorite account could be closed which will cause the AFT to fail.

  # Requisition item just created is presumed to be the last item in the zero-based collection.
  # Value used multiple times once so retrieve once and reuse.
  new_item_index = @requisition.items.length-1
  on ItemsTab do |item_tab|
    item_tab.show_item_accounting_lines(new_item_index) if item_tab.item_accounting_lines_hidden?(new_item_index)
    if item_tab.update_chart_code(new_item_index).exists?
      # User's favorite account could be closed.
      # Set accounting line to known good value by deleting the favorite account and adding a known good account.
      item_tab.delete_item_accounting_line(new_item_index)
      step 'I add an Accounting Line to the Requisition Item just created'
    else
      step 'I add an Accounting Line to the Requisition Item just created'
    end
  end
end


And /^I add an Accounting Line to the Requisition Item just created$/ do
  # Requisition item just created is presumed to be the last item in the zero-based collection.
  # Value used multiple times once so retrieve once and reuse.
  new_item_index = @requisition.items.length-1
  on ItemsTab do |item_tab|
    # Get a random account number
    item_tab.show_item_accounting_lines(new_item_index) if item_tab.item_accounting_lines_hidden?(new_item_index)
    item_tab.account_number_new_search(new_item_index)
    on AccountLookupPage do |acct_lookup|
      acct_lookup.sub_fund_group_code.set (get_aft_parameter_values_as_hash(ParameterConstants::DEFAULTS_FOR_ITEMS))[:account_subfund_lookup]
      acct_lookup.search
      acct_lookup.wait_for_search_results
      acct_lookup.return_random
    end
    # Attempt a set number of times to obtain a random object code with the AFT parameter specified Object Level and
    # Object Sub-Type values that should not cause a business rule error for the Object Sub-Type code assigned to the
    # random Object Code using the default Chart and Percent values.
    max_num_searches = 10
    number_object_search_attempts = 0
    begin
      item_tab.object_code_new_search(new_item_index)
      on ObjectCodeLookupPage do |obj_lookup|
        obj_lookup.level_code.set (get_aft_parameter_values_as_hash(ParameterConstants::DEFAULTS_FOR_ITEMS))[:object_level_lookup]
        obj_lookup.object_sub_type_code.set (get_aft_parameter_values_as_hash(ParameterConstants::DEFAULTS_FOR_ITEMS))[:object_sub_type_lookup]
        obj_lookup.search
        obj_lookup.wait_for_search_results
        obj_lookup.return_random
      end
      number_object_search_attempts +=1
      # business rules are verified when add button is pressed
      item_tab.add_item_accounting_line(new_item_index)
      page_errors = $current_page.errors
    end while !(page_errors == []) && number_object_search_attempts < max_num_searches #while-object code business rule failure
    # Get page data in backing object prior to failure check so it is known why should failure occur
    @requisition.items.update_from_page! :new
    fail ArgumentError, "Attempted #{max_num_searches} times to find Object Code with an Object Level of #{((get_aft_parameter_values_as_hash(ParameterConstants::DEFAULTS_FOR_ITEMS))[:object_level_lookup])} and an Object SubType of #{((get_aft_parameter_values_as_hash(ParameterConstants::DEFAULTS_FOR_ITEMS))[:object_sub_type_lookup])} but each Object Code selected generated a business rule error when attempting to add the Account." if number_object_search_attempts == max_num_searches
  end
end


And /^I add a restricted Vendor to the Requisition$/ do
  on RequisitionPage do |req_page|
    req_page.clear_vendor
    req_page.suggested_vendor_search
    on VendorLookupPage do |vendor_lookup|
      restricted_vendor_number = get_restricted_vendor_number
      vendor_lookup.vendor_number.set restricted_vendor_number
      vendor_lookup.search
      vendor_lookup.wait_for_search_results
      vendor_lookup.return_random
    end
  end
  #absorb for requisition vendor data needs to be created if this data is required by future AFT steps, currently not required
end


Then /^a Commodity Reviewer does (.*) a Pending or Future Action approval request for the (sensitive|non\-sensitive) Commodity Code$/ do |existence_check, commodity_code_type|
  # verify that Pending Action Requests OR Future Action Requests (do|do not) show routing to Commodity Reviewer
  role_exists_in_pending = false
  role_exists_in_future = false

  on(KFSBasePage) do |page|
    page.expand_all
    page.show_pending_action_requests if page.show_pending_action_requests_button.exists?
    page.show_future_action_requests if page.show_future_action_requests_button.exists?

    annotation_pending_col = page.pnd_act_req_table.keyed_column_index(:annotation)
    pending_cr_row = page.pnd_act_req_table
                         .column(annotation_pending_col)
                         .index{ |c| c.exists? && c.visible? && c.text.match(/Commodity Reviewer/) }
    if pending_cr_row.nil?
      role_exists_in_pending = false
    else
      role_exists_in_pending = true
    end

    annotation_future_col = page.future_actions_table.keyed_column_index(:annotation)
    future_cr_row = page.future_actions_table
                        .column(annotation_future_col)
                        .index{ |c| c.exists? && c.visible? && c.text.match(/Commodity Reviewer/) }
    if future_cr_row.nil?
      role_exists_in_future = false
    else
      role_exists_in_future = true
    end
  end

  case existence_check
    when 'have'
      (role_exists_in_pending || role_exists_in_future).should == true
    when 'not have'
      role_exists_in_pending.should == false
      role_exists_in_future.should == false
  end
end


Then /^the Requisition Document Status is (.*)$/ do |status_desired|
  on RequisitionPage do |req_page|
    (req_page.requisition_status).should == status_desired
  end
end
