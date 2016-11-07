Then /^"([^"]*)" should not be displayed in the Accounting Line section$/ do |msg|
  on(AdvanceDepositPage).errors.should_not include msg
end

And /^I lookup the (Encumbrance|Disencumbrance|Source|Target|From|To) Accounting Line for the (.*) document via Available Balances with these options selected:$/ do |al_type, document, table|
  doc_object = document_object_for(document)
  alt = AccountingLineObject::get_type_conversion(al_type)

  visit(MainPage).available_balances
  on AvailableBalancesLookupPage do |lookup|
    lookup.fiscal_year.fit                  get_aft_parameter_value(ParameterConstants::CURRENT_FISCAL_YEAR)
    lookup.chart_code.fit                   doc_object.accounting_lines[alt].first.chart_code # We're assuming this exists, of course.
    lookup.account_number.fit               doc_object.accounting_lines[alt].first.account_number
    lookup.send("consolidation_option_#{snake_case(table.rows_hash['Consolidation Option']).to_s}") unless table.rows_hash['Consolidation Option'].nil?
    lookup.send("include_pending_entry_approved_indicator_#{table.rows_hash['Include Pending Ledger Entry'].downcase}") unless table.rows_hash['Include Pending Ledger Entry'].nil?
    lookup.search
    lookup.wait_for_search_results(90)
  end
end

And /^these fields in the Available Balances lookup match the ones submitted in the (.*) document:$/ do |document, table|
  # Note: This assumes you're already on the Available Balances lookup page and have run the lookup
  doc_object = document_object_for(document)
  lookup_cols = table.raw.flatten.collect { |f| on(AvailableBalancesLookupPage).column_index(snake_case(f)) }

  lookup_cols.each do |col|
    case col
      when :encumbrance_amount
        on(AvailableBalancesLookupPage).column(col).any? { |cell| cell.text == doc_object.accounting_lines[:source].first.amount }
      else
        # Do nothing
    end
  end
end

And /^the (Encumbrance|Disencumbrance|Source|Target|From|To) Accounting Line entry matches the (.*) document's entry$/ do |al_type, document|
  doc_object = document_object_for(document)
  alt = AccountingLineObject::get_type_conversion(al_type)
  on AccountingLine do |entry_page|
    # We're going to just compare against the first submitted line
    ((entry_page.send("result_#{alt.to_s}_chart_code")).should == doc_object.accounting_lines[alt].first.chart_code) unless doc_object.accounting_lines[alt].first.chart_code.nil?
    ((entry_page.send("result_#{alt.to_s}_account_number")).should == doc_object.accounting_lines[alt].first.account_number) unless doc_object.accounting_lines[alt].first.account_number.nil?
    ((entry_page.send("result_#{alt.to_s}_sub_account_code")).should == doc_object.accounting_lines[alt].first.sub_account) unless doc_object.accounting_lines[alt].first.sub_account.nil?
    ((entry_page.send("result_#{alt.to_s}_object_code")).should == doc_object.accounting_lines[alt].first.object) unless doc_object.accounting_lines[alt].first.object.nil?
    ((entry_page.send("result_#{alt.to_s}_sub_object_code")).should == doc_object.accounting_lines[alt].first.sub_object) unless doc_object.accounting_lines[alt].first.sub_object.nil?
    ((entry_page.send("result_#{alt.to_s}_project_code")).should == doc_object.accounting_lines[alt].first.project) unless doc_object.accounting_lines[alt].first.project.nil?
    ((entry_page.send("result_#{alt.to_s}_organization_reference_id")).should == doc_object.accounting_lines[alt].first.org_ref_id) unless doc_object.accounting_lines[alt].first.org_ref_id.nil?
    ((entry_page.send("result_#{alt.to_s}_line_description")).should == doc_object.accounting_lines[alt].first.line_description) unless doc_object.accounting_lines[alt].first.line_description.nil?
    ((entry_page.send("result_#{alt.to_s}_reference_origin_code")).should == doc_object.accounting_lines[alt].first.reference_origin_code) unless doc_object.accounting_lines[alt].first.reference_origin_code.nil?
    ((entry_page.send("result_#{alt.to_s}_reference_number")).should == doc_object.accounting_lines[alt].first.reference_number) unless doc_object.accounting_lines[alt].first.reference_number.nil?
    # Amounts must be compared as cents because "to_f" will truncate to a whole number in certain cases.
    # example: "4,000.00".to_f becomes 4.0 which does not represent the amount correctly.
    (to_cents_i(entry_page.send("result_#{alt.to_s}_amount")).should == to_cents_i(doc_object.accounting_lines[alt].first.amount)) unless doc_object.accounting_lines[alt].first.amount.nil?
    (to_cents_i(entry_page.send("result_#{alt.to_s}_base_amount")).should == to_cents_i(doc_object.accounting_lines[alt].first.base_amount)) unless doc_object.accounting_lines[alt].first.base_amount.nil?
    (to_cents_i(entry_page.send("result_#{alt.to_s}_current_amount")).should == to_cents_i(doc_object.accounting_lines[alt].first.current_amount)) unless doc_object.accounting_lines[alt].first.current_amount.nil?
  end
end

When /^I add a (source|target) Accounting Line for the (.*) document$/ do |line_type, document|
  doc_object = snake_case document

  on page_class_for(document) do
    case line_type
      when 'source'
        get(doc_object).
            add_source_line({
                                chart_code:               @account.chart_code,
                                account_number:           @account.number,
                                object:                   '4480',
                                reference_origin_code:    '01',
                                reference_number:         '777001',
                                amount:                   '25000.11'
                            })
      when 'target'
        get(doc_object).
            add_target_line({
                                chart_code:               @account.chart_code,
                                account_number:           @account.number,
                                object:                   '4480',
                                reference_origin_code:    '01',
                                reference_number:         '777002',
                                amount:                   '25000.11'
                            })
    end
  end
end

When /^I enter a (source|target) Accounting Line Description on the (.*) document$/ do |line_type, document|
  doc_object = get(snake_case(document))
  doc_object.accounting_lines[line_type.to_sym][0].edit line_description: "Hey #{line_type} edit works!"
end

When /^I remove (source|target) Accounting Line #([0-9]*) from the (.*) document$/ do |line_type, line_number, document|
  get(snake_case(document)).accounting_lines[line_type.to_sym].delete_at(line_number.to_i - 1)
end

And /^I add a (Source|Target|From|To) Accounting Line to the (.*) document with the following:$/ do |line_type, document, table|
  accounting_line_info = table.rows_hash
  accounting_line_info.delete_if { |k,v| v.empty? }
  unless accounting_line_info['Number'].nil?
    doc_object = snake_case document

    on page_class_for(document) do
      case line_type
        when 'Source', 'From'
          new_source_line = {
              chart_code:     accounting_line_info['Chart Code'],
              account_number: accounting_line_info['Number'],
              object:         accounting_line_info['Object Code'],
              amount:         accounting_line_info['Amount']
          }
          case document
            when'Budget Adjustment'
              new_source_line.merge!({
                                         object:         '6510',
                                         current_amount: accounting_line_info['Amount']
                                     })
              new_source_line.delete(:amount)
            when 'Advance Deposit'
            when'Auxiliary Voucher', 'Journal Voucher'
              new_source_line.merge!({
                                         object: '6690',
                                         debit:  accounting_line_info['Amount']
                                     })
              new_source_line.delete(:amount)
              get(doc_object).add_source_line(new_source_line)
              new_source_line.merge!({
                                         credit:  accounting_line_info['Amount']
                                     })
              new_source_line.delete(:debit)
            when 'General Error Correction'
              new_source_line.merge!({
                                         reference_number:      '777001',
                                         reference_origin_code: '01'
                                     })
            when 'Pre-Encumbrance'
              if accounting_line_info.has_key?'Auto Disencumber Type'
                new_source_line.merge!({
                                           auto_dis_encumber_type:    accounting_line_info['Auto Disencumber Type'],
                                           partial_transaction_count: accounting_line_info['Partial Transaction Count'],
                                           partial_amount:            accounting_line_info['Partial Amount'],
                                           start_date:                accounting_line_info['Start Date']
                                       })
              end
            when 'Internal Billing', 'Service Billing'
              new_source_line.merge!({
                                         object: '4023'
                                     })
            when 'Indirect Cost Adjustment'
              new_source_line.delete(:object)
            when 'Non-Check Disbursement'
              new_source_line.merge!({
                                         reference_number:      '777001'
                                     })
            when 'Transfer Of Funds'
              new_source_line.merge!({
                                         object: '8070'
                                     })
            when 'Disbursement Voucher'
              new_source_line.merge!({
                                         object: '6100'
                                     })
            else
          end
          get(doc_object).add_source_line(new_source_line)
        when 'Target', 'To'
          new_target_line = {
              chart_code:     accounting_line_info['Chart Code'],
              account_number: accounting_line_info['Number'],
              object:         accounting_line_info['Object Code'],
              amount:         accounting_line_info['Amount']
          }
          case document
            when'Budget Adjustment'
              new_target_line.merge!({
                                         object:         '6540',
                                         current_amount: accounting_line_info['Amount']
                                     })
              new_target_line.delete(:amount)
            when'General Error Correction'
              new_target_line.merge!({
                                         reference_number:      '777002',
                                         reference_origin_code: '01'
                                     })
            when 'Pre-Encumbrance'
              if accounting_line_info.has_key?'Reference Number'
                new_target_line.merge!({
                                           reference_number:    accounting_line_info['Reference Number']
                                       })
              end
            when 'Internal Billing', 'Service Billing'
              new_target_line.merge!({
                                         object: '4023'
                                     })
            when 'Indirect Cost Adjustment'
              new_target_line.delete(:object)
            when 'Transfer Of Funds'
              new_target_line.merge!({
                                         object: '7070'
                                     })
          end
          get(doc_object).add_target_line(new_target_line)
      end
    end
  end
end
