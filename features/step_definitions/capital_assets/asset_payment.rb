When /^I start an empty Asset Manual Payment document$/ do
  @asset_manual_payment = create AssetManualPaymentObject
end


And /^I add Asset Line (\d+) with Allocation Amount (\w+)$/ do |line_number, amount|
  on AssetManualPaymentPage do |page|
    page.asset_number.fit fetch_random_capital_asset_number
    page.add_asset_number
    page.allocate_amount(line_number.to_i - 1).fit amount  #page array is zero based, adjust line number
    #ensure data object backing the page also has data just entered
    @asset_manual_payment.asset_lines = @asset_manual_payment.pull_all_asset_lines(page)
  end
end


And /^I add an Accounting Line to the Asset Manual Payment with Amount (\w+)$/ do |amount|
  on AssetManualPaymentPage do |page|
    page.source_account_number.fit  get_random_account_number
    page.source_object_code.fit     fetch_random_capital_asset_object_code
    page.source_amount.fit          amount
    page.source_posted_date.fit     right_now[:date_w_slashes] #Use today for default value as this is required data
    page.add_acct_line
    #ensure data object backing the page also has values just entered
    @asset_manual_payment.accounting_lines = @asset_manual_payment.pull_all_accounting_lines(page)
  end
end


And /^I change the Account Amount for Accounting Line (\d+) to (\w+) for Asset Manual Payment$/ do |line_number, new_value|
  on(AssetManualPaymentPage) do |page|
    page.asset_manual_payment_update_amount(:source, line_number.to_i - 1).fit new_value  #page array is zero based, adjust line number
    # ensure data object backing the page also has value just updated,
    # we know line number and new value just brute force update the backing object.
    # page method(s) pull_all_accounting_lines or pull_existing_accounting_line_values with a merge to the existing
    # hash was not performed here due to the time sync of processing a large number of accounting line attributes
    # for just a single value being changed.
    @asset_manual_payment.accounting_lines[line_number.to_i - 1][:amount] = new_value
  end
end
