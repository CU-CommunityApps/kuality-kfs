Then /^the Pre-Encumbrance posts a GL Entry with one of the following statuses$/ do |required_statuses|
  visit(MainPage).general_ledger_entry
  on(GeneralLedgerEntryLookupPage).find_encumbrance_doc(@pre_encumbrance)
  on(PreEncumbrancePage) { |b| required_statuses.raw.flatten.should include b.document_status }
end

When /^I start an empty Pre\-Encumbrance document$/ do
  @pre_encumbrance = create PreEncumbranceObject
  step 'I add the encumbrance to the stack'
end

When /^I (.*) a Pre-Encumbrance document with an Encumbrance Accounting Line for the current Month$/ do |button|
  step "I #{button} a Pre-Encumbrance document that encumbers a random Account" # This works because the default is the current month
end

Then /^the Open Encumbrances lookup for the Pre-Encumbrance document with Balance Type (.*) Includes All Pending Entries$/ do |balance_type|
  visit(MainPage).open_encumbrances
  on OpenEncumbranceLookupPage do |page|
    page.doc_number.set @pre_encumbrance.document_id
    page.balance_type_code.set balance_type
    page.active_indicator_all.set
    page.search
    page.wait_for_search_results(90)

    fiscal_year_col = page.results_table.keyed_column_index(:fiscal_year)
    chart_code_col = page.results_table.keyed_column_index(:chart_code)
    account_number_col = page.results_table.keyed_column_index(:account_number)
    object_code_col = page.results_table.keyed_column_index(:object_code)
    document_number_col = page.results_table.keyed_column_index(:document_number)
    # first row is column headers, rest is data
    page.results_table.rows.length.should == 2
    page.results_table.rest.each do |row|
      row[document_number_col].text.strip.should == @pre_encumbrance.document_id &&
      row[chart_code_col].text.strip.should == @account.chart_code &&
      row[account_number_col].text.strip.should == @account.number &&
      row[fiscal_year_col].text.strip.should == @object_code.fiscal_year &&
      row[object_code_col].text.strip.should == @object_code.object_code
    end
  end
end

And /^I add the (encumbrance|disencumbrance) to the stack$/ do |type|
  if @pre_encumbrances.nil?
    @pre_encumbrances = {type.to_sym => [@pre_encumbrance]}
  elsif @pre_encumbrances[type.to_sym].nil?
    @pre_encumbrances.merge!({type.to_sym => [@pre_encumbrance]})
  else
    @pre_encumbrances[type.to_sym] << @pre_encumbrance
  end
end

Then /^Open Encumbrance Lookup Results for the Account just used with Balance Type (.*) for (No|Approved|All) Pending Entries and (Include|Exclude) Zeroed Out Encumbrances will display the disencumbered amount in both open and closed amounts with outstanding amount zero$/ do |balance_type, pending_option, zeroed_option|
  visit(MainPage).open_encumbrances
  on OpenEncumbranceLookupPage do |page|
    page.chart_code.set @account.chart_code
    page.account_number.set @account.number
    page.balance_type_code.set balance_type
    if pending_option == 'Approved'
      page.active_indicator_approved.set
    elsif pending_option == 'All'
      page.active_indicator_all.set
    else
      page.active_indicator_no.set
    end
    if zeroed_option == 'Include'
      page.including_zeroed_out_encumbrances_include.set
    else
      page.including_zeroed_out_encumbrances_exclude.set
    end
    page.search

    # obtain column values once and reuse
    doc_num_col = page.results_table.keyed_column_index(:document_number)
    open_amt_col = page.results_table.keyed_column_index(:open_amount)
    closed_amt_col = page.results_table.keyed_column_index(:closed_amount)
    outstanding_amt_col = page.results_table.keyed_column_index(:outstanding_amount)
    #determine whether data returned by search is what we expected
    disencumbered_valid = false
    new_encumbered_valid = false
    # The open encumbrance lookup should display the disencumbered amount in both open and closed amounts with outstanding amount zero.
    # The open encumbrance lookup should display the total encumbrance amount in the open amount column for the new encumbrance.
    # Convert all amounts to numeric cents for comparison because string compare of 250.00 will NOT equal 250.0 even though they are technically equal
    expected_open_encumbered_amount =  to_cents_i(@encumbrance_amount)
    expected_outstanding_disencumbered_amount = to_cents_i("0.00")
    expected_disencumbered_amount = to_cents_i(@disencumbrance_amount)

    # Since some of the accounts may have other encumbrances listed, the description on the pre-encumbrance edoc will
    # match the description on the lookup, to identify the line on which the dollars outlined above should appear.
    page.results_table.rest.each do |row|
      row_open_amount = to_cents_i(row[open_amt_col].text)
      row_closed_amount = to_cents_i(row[closed_amt_col].text)
      row_outstanding_amount = to_cents_i(row[outstanding_amt_col].text)
      if row[doc_num_col].text.strip == @remembered_document_id and row_open_amount == expected_disencumbered_amount and row_closed_amount == expected_disencumbered_amount and row_outstanding_amount == expected_outstanding_disencumbered_amount
        disencumbered_valid = true
      elsif row[doc_num_col].text.strip == @retained_document_id and row_open_amount == expected_open_encumbered_amount
        new_encumbered_valid = true
      else
        #do nothing
      end
    end
    results = disencumbered_valid and new_encumbered_valid
    results.should be true
  end
end
