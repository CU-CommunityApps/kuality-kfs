When /^I perform a (.*) Lookup using account number (.*)$/ do |gl_balance_inquiry_lookup, account_number|
  gl_balance_inquiry_lookup = gl_balance_inquiry_lookup.gsub!(' ', '_').downcase
  visit(MainPage).send(gl_balance_inquiry_lookup)
  if gl_balance_inquiry_lookup == 'current_fund_balance'
    on CurrentFundBalanceLookupPage do |page|
      page.chart_code.fit     get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
      page.account_number.fit account_number
      page.search
    end
  else
    on GeneralLedgerEntryLookupPage do |page|
      page.chart_code.fit     get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
      page.account_number.fit account_number
      page.search
    end
  end
end

Then /^the (.*) document GL Entry Lookup matches the document's GL entry$/ do |document|
  step "I lookup the Source Accounting Line of the #{document} document in the GL"

  on GeneralLedgerEntryLookupPage do |page|
    tled_col = page.results_table.keyed_column_index(:transaction_ledger_entry_description)
    tlea_col = page.results_table.keyed_column_index(:transaction_ledger_entry_amount)
    oc_col = page.results_table.keyed_column_index(:object_code)
    peai_col = page.results_table.keyed_column_index(:pending_entry_approved_indicator)
    rdn_col = page.results_table.keyed_column_index(:reference_document_number)

    page.results_table.column(tled_col).rest.map(&:text).should include 'TP Generated Offset' # This verifies that the offset was actually generated.

    document_object_for(document).accounting_lines.each_value do |als|
      als.each do |al|
        page.item_row(al.object)[oc_col].text.should == al.object
        page.item_row(al.object)[tled_col].text.should == al.line_description
        # Amounts must be compared as cents because "to_f" will truncate to a whole number in certain cases.
        # example: "4,000.00".to_f becomes 4.0 which does not represent the amount correctly.
        to_cents_i(page.item_row(al.object)[tlea_col].text).should == to_cents_i(al.amount)
        page.item_row(al.object)[peai_col].text.should == ''
        page.item_row(al.object)[rdn_col].text.should == document_object_for(document).document_id
      end
    end
  end
end

And /^the (.*) document has matching GL and GLPE offsets$/ do |document|
  step "I lookup the offset for the #{document} document in the document's GLPE entry"
  step "I lookup the offset for the #{document} document in the document's GL entry"
  @glpe_offset_amount.should == @gl_offset_amount
end

And /^I lookup the offset for the (.*) document in the document's GLPE entry$/ do |document|
  step "I lookup the Source Accounting Line of the #{document} document in the GLPE"

  on GeneralLedgerPendingEntryLookupPage do |page|
    tled_col = page.results_table.keyed_column_index(:transaction_ledger_entry_description)
    tlea_col = page.results_table.keyed_column_index(:transaction_ledger_entry_amount)

    page.results_table.column(tled_col).rest.length.should == 2 # We must get two lines to know the offset was generated.
    page.results_table.column(tled_col).rest.map(&:text).should include 'TP Generated Offset' # This verifies that the offset was actually generated.

    document_object_for(document).accounting_lines.each_value do |als|
      als.each do |al|
        # Amounts must be compared as cents because "to_f" will truncate to a whole number in certain cases.
        # example: "4,000.00".to_f becomes 4.0 which does not represent the amount correctly.
        @glpe_offset_amount = to_cents_i(al.amount) if @glpe_offset_amount.nil? # Grab it on the first go.

        @glpe_offset_amount.should == to_cents_i(al.amount) # If this gets tripped, we added multiple lines and we probably need to refactor.

        # Now match both lines.
        to_cents_i(page.item_row(al.line_description)[tlea_col].text).should == @glpe_offset_amount
        to_cents_i(page.item_row('TP Generated Offset')[tlea_col].text).should == @glpe_offset_amount

      end
    end
  end
end

And /^I lookup the offset for the (.*) document in the document's GL entry$/ do |document|
  step "I lookup the Source Accounting Line of the #{document} document in the GL"

  on GeneralLedgerEntryLookupPage do |page|
    tled_col = page.results_table.keyed_column_index(:transaction_ledger_entry_description)
    tlea_col = page.results_table.keyed_column_index(:transaction_ledger_entry_amount)

    page.results_table.column(tled_col).rest.length.should == 2 # We must get two lines to know the offset was generated.
    page.results_table.column(tled_col).rest.map(&:text).should include 'TP Generated Offset' # This verifies that the offset was actually generated.

    document_object_for(document).accounting_lines.each_value do |als|
      als.each do |al|
        # Amounts must be compared as cents because "to_f" will truncate to a whole number in certain cases.
        # example: "4,000.00".to_f becomes 4.0 which does not represent the amount correctly.
        @gl_offset_amount = to_cents_i(al.amount) if @gl_offset_amount.nil? # Grab it on the first go.

        @gl_offset_amount.should == to_cents_i(al.amount) # If this gets tripped, we added multiple lines and we probably need to refactor.

        # Now match both lines.
        to_cents_i(page.item_row(al.line_description)[tlea_col].text).should == @gl_offset_amount
        to_cents_i(page.item_row('TP Generated Offset')[tlea_col].text).should == @gl_offset_amount

      end
    end
  end
end

And /^the Object Codes for the (.*) document appear in the document's GLPE entry$/ do |document|
  step "I lookup the Source Accounting Line of the #{document} document in the GLPE"

  on GeneralLedgerPendingEntryLookupPage do |page|
    document_object_for(document).accounting_lines.each_value do |als|
      als.each do |al|
        # This pulls the text of the Object Code column and makes sure the
        # Object Codes in each Accounting Line of the object are in that column.
        page.results_table.column(page.results_table.keyed_column_index(:object_code)).rest.map(&:text).should include al.object
      end
    end
  end
end

And /^I lookup the (Encumbrance|Disencumbrance|Source|Target|From|To) Accounting Line of the (.*) document in the GLPE$/ do |al_type, document|
  doc_object = document_object_for(document)
  alt = AccountingLineObject::get_type_conversion(al_type)

  visit(MainPage).general_ledger_pending_entry
  on GeneralLedgerPendingEntryLookupPage do |page|
    page.balance_type_code.fit         ''
    page.chart_code.fit                doc_object.accounting_lines[alt][0].chart_code # We're assuming this exists, of course.
    page.fiscal_year.fit               get_aft_parameter_value(ParameterConstants::CURRENT_FISCAL_YEAR)
    page.fiscal_period.fit             fiscal_period_conversion(right_now[:MON])
    page.account_number.fit            '*'
    page.reference_document_number.fit doc_object.document_id
    page.pending_entry_all.set
    page.search
    page.wait_for_search_results(90)
  end
end

And /^I lookup the (Encumbrance|Disencumbrance|Source|Target|From|To) Accounting Line of the (.*) document in the GL$/ do |al_type, document|
  doc_object = document_object_for(document)
  alt = AccountingLineObject::get_type_conversion(al_type)

  visit(MainPage).general_ledger_entry
  on GeneralLedgerEntryLookupPage do |page|
    page.balance_type_code.fit         ''
    page.chart_code.fit                doc_object.accounting_lines[alt][0].chart_code # We're assuming this exists, of course.
    page.fiscal_year.fit               get_aft_parameter_value(ParameterConstants::CURRENT_FISCAL_YEAR)
    page.fiscal_period.fit             fiscal_period_conversion(right_now[:MON])
    page.account_number.fit            '*'
    page.reference_document_number.fit doc_object.document_id
    page.pending_entry_approved_indicator_all
    begin
      page.search
    rescue Timeout::Error
      raise StandardError.new("Timeout::Error caught for page.search in step [I lookup the #{al_type} Accounting Line of the #{document} document in the GL]")
    end
    begin
      page.wait_for_search_results
    rescue Timeout::Error
      clock = Time.new
      puts "RESCUE Timeout::Error caught for wait_for_search_results in step [I lookup the #{al_type} Accounting Line of the #{document} document in the GL] : Current Time : #{clock.inspect}"
      puts "Sleeping for 7 mintues so database cache can build."
      # This could be the first execution - cache build wait a bit longer
      sleep(420)
      clock = Time.new
      puts "After sleep in Rescue block : Current Time : #{clock.inspect}"
    end
  end
end

And /^I lookup the (Encumbrance|Disencumbrance|Source|Target|From|To) Accounting Line of the (.*) document in the General Ledger Balance$/ do |al_type, document|
  doc_object = document_object_for(document)
  alt = AccountingLineObject::get_type_conversion(al_type)

  visit(MainPage).general_ledger_balance
  on GeneralLedgerBalanceLookupPage do |page|
    page.balance_type_code.fit         ''
    page.chart_code.fit                doc_object.accounting_lines[alt][0].chart_code # We're assuming this exists, of course.
    page.fiscal_year.fit               get_aft_parameter_value(ParameterConstants::CURRENT_FISCAL_YEAR)
    page.fiscal_period.fit             fiscal_period_conversion(right_now[:MON])
    page.account_number.fit            '*'
    page.reference_document_number.fit doc_object.document_id
    page.pending_entry_all.set
    page.search
    page.wait_for_search_results(90)
  end
end

Then /^the (.*) document has General Ledger Balance transactions matching the accounting lines from the (.*) document$/ do |transaction_doc, lines_doc|
  pending
end

And /^the recovery (.*) specified in the (.*) document have posted income transactions in the General Ledger Balance$/ do |transaction_doc, lines_doc|
  pending
end
