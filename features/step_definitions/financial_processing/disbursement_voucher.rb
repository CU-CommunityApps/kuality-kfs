When /^I start an empty Disbursement Voucher document$/ do
  @disbursement_voucher = create DisbursementVoucherObject
end

When /^I start an empty Disbursement Voucher document with Payment to Employee (.*)$/ do |net_id|
  @disbursement_voucher = create DisbursementVoucherObject, payee_id: net_id, vendor_payee: false
end

And /^I add the only payee with Payee Id (\w+) and Reason Code (\w+) to the Disbursement Voucher$/ do |net_id, reason_code|
  case reason_code
    when 'B'
      @disbursement_voucher.payment_reason_code = 'B - Reimbursement for Out-of-Pocket Expenses'
  end
  on (PaymentInformationTab) do |tab|
    tab.payee_search
    on PayeeLookup do |plookup|
      plookup.payment_reason_code.fit @disbursement_voucher.payment_reason_code
      plookup.netid.fit               net_id
      plookup.search
      plookup.results_table.rows.length.should == 2 # header and value
      plookup.return_value(net_id)
    end
    @disbursement_voucher.fill_in_payment_info(tab)
  end
end

And /^I add an Accounting Line to the Disbursement Voucher with the following fields:$/ do |table|
  accounting_line_info = table.rows_hash
  accounting_line_info.delete_if { |k,v| v.empty? }
  on (PaymentInformationTab) {|tab| tab.check_amount.fit accounting_line_info['Amount']}
  @disbursement_voucher.add_source_line({
                                            account_number: accounting_line_info['Number'],
                                            object: accounting_line_info['Object Code'],
                                            amount: accounting_line_info['Amount'],
                                            line_description: accounting_line_info['Description']
                                        })
end

And /^I search for the payee with Terminated Employee and Reason Code (\w+) for Disbursement Voucher document with no result found$/ do |reason_code|
  net_id = "msw13" # TODO : should get this from web services. Inactive employee with no other affiliation
  case reason_code
    when 'B'
      @disbursement_voucher.payment_reason_code = 'B - Reimbursement for Out-of-Pocket Expenses'
  end
  on(PaymentInformationTab).payee_search
  on PayeeLookup do |plookup|
    plookup.payment_reason_code.fit @disbursement_voucher.payment_reason_code
    plookup.netid.fit               net_id
    plookup.search
    plookup.frm.divs(id: 'lookup')[0].parent.text.should include 'No values match this search'
  end
end

And /^I add an? (.*) as payee and Reason Code (\w+) to the Disbursement Voucher$/ do |payee_status, reason_code|
  case payee_status
    when 'Retiree'
      @payee_net_id = "map3" # TODO : should get from web service
    when 'Active Staff, Former Student, and Alumnus'
      @payee_net_id = "nms32" # TODO : should get from web service or parameter
    when 'Active Employee, Former Student, and Alumnus'
      @payee_net_id = "vk76" # TODO : should get from web service or parameter. vk76 is inactive now.
    when 'Inactive Employee and Alumnus'
      @payee_net_id = "rlg3" # TODO : should get from web service or parameter.
  end
  step "I add the only payee with Payee Id #{@payee_net_id} and Reason Code #{reason_code} to the Disbursement Voucher"
end
