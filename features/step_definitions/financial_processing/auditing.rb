And /^on the (.*) document I modify the (From|To) Object Code line item (\d+) to be (.*)$/ do |document, from_or_to, line_item, new_object_code|
  document_object_for(document).accounting_lines[AccountingLineObject::get_type_conversion(from_or_to)][line_item.to_i]
                               .edit object: new_object_code
  on(AccountingLine).send("update_#{AccountingLineObject::get_type_conversion(from_or_to)}_object_code", line_item)
                    .value
                    .should == new_object_code
end

And /^on the (.*) document I modify the Object Code line item (\d+) to be (.*)$/ do |document, line_item, new_object_code|
  document_object_for(document).accounting_lines[:source][line_item.to_i]
                               .edit object: new_object_code
  on(AccountingLine).update_source_object_code(line_item)
                    .value
                    .should == new_object_code
end

Then /^The Notes and Attachment Tab displays "Accounting Line changed from"$/ do
  on AuxiliaryVoucherPage do |page|
    page.expand_all
    page.account_line_changed_text.should exist
  end
end

And /^I add a (From|To) accounting line to the (.*) document with:$/ do |from_or_to, document, table|
  updates = table.rows_hash

  case from_or_to
    when 'From'
      on page_class_for(document) do
        document_object_for(document).add_source_line({
                                            account_number: updates['from account number'],
                                            object: updates['from object code'],
                                            amount: updates['from amount']
                                        })
      end
    when 'To'
      on page_class_for(document) do
        document_object_for(document).add_target_line({
                                            account_number: updates['to account number'],
                                            object: updates['to object code'],
                                            amount: updates['to amount']
                                        })
      end
    else
      pending 'If you are seeing this message, you have done something very wrong.'
  end
end
