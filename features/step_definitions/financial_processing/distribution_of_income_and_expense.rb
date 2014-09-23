When /^I start an empty Distribution Of Income And Expense document$/ do
  @distribution_of_income_and_expense = create DistributionOfIncomeAndExpenseObject, initial_lines: []
end

And /^I change the DI from Account to one not owned by the current user$/ do
  @distribution_of_income_and_expense.accounting_lines['source'.to_sym][0].edit account_number: "A763900"
end

And /^I change the DI from Account to one owned by the current user$/ do
  @distribution_of_income_and_expense.accounting_lines['source'.to_sym][0].edit account_number: "1753302"
end

And /^I add a (From|To) amount of "(.*)" for account "(.*)" with object code "(.*)" with a line description of "(.*)" to the DI Document$/  do |target, amount, account_number, object_code, line_desc|
  on DistributionOfIncomeAndExpensePage do |page|
    case target
      when 'From'
        @distribution_of_income_and_expense.add_source_line({
                                               account_number:   account_number,
                                               object:           object_code,
                                               amount:           amount,
                                               line_description: line_desc
                                           })
      when 'To'
        @distribution_of_income_and_expense.add_target_line({
                                               account_number:   account_number,
                                               object:           object_code,
                                               amount:           amount,
                                               line_description: line_desc
                                           })
    end
  end
end

And /^I select accounting line \#(\d+) and (create|modify) Capital Asset$/ do |il, action|
  il = il.to_i - 1
  on CapitalAssetsTab do |tab|
    tab.generate_accounting_lines_for_capitalization unless tab.accounting_lines_for_capitalization_select(il).exists?
    tab.accounting_lines_for_capitalization_select(il).set
    tab.distribution_method.fit 'Distribute cost by amount'
    case action
      when 'create'
        tab.create_asset
      when 'modify'
        tab.modify_asset
    end
  end
end

And /^I distribute a new Capital Asset amount$/ do
  on CapitalAssetsTab do |tab|
    i = tab.current_asset_count.to_i - 1
    @new_asset_account_number = tab.asset_account_number(i)
    @distribution_of_income_and_expense.assets.add   qty:           '1',
                                                     type:          '019',
                                                     manufacturer:  'CA manufacturer',
                                                     description:   random_alphanums(40, 'AFT'),
                                                     line_amount:   tab.remain_asset_amount
    tab.redistribute_amount
  end
end

And /^I distribute the modify Capital Asset amount$/ do
  on CapitalAssetsTab do |tab|
    i = tab.current_asset_count.to_i - 1
    @modify_asset_account_number = tab.asset_account_number(i)
    tab.line_amount(i).fit tab.remain_asset_amount
    tab.number(i).fit @asset_number
    tab.redistribute_modify_amount
  end
end

And /^I build a Capital Asset from the General Ledger$/ do
  step 'I Login as an Asset Processor'
  step "I lookup a Capital Asset with Account Number of #{@new_asset_account_number} from GL transaction to process"
  step 'I create asset from General Ledger Processing'
  step 'I submit the Asset Global document'
  step 'the Asset Global document goes to FINAL'
  step "check payments tab for correct account and amount with following:",
       table(%Q{
              | Asset Number    | #{@new_asset_number}            |
              | Account Number  | #{@new_asset_account_number}   |
              | Amount          | #{@asset_amount}           |
         })
end

And /^I lookup a Capital Asset with Account Number of (.*) from GL transaction to process$/ do |account_number|
  visit(MainPage).capital_asset_builder_gl_transactions
  on GeneralLedgerPendingEntryLookupPage do |page|
    page.account_number.fit account_number
    page.search
    page.process(account_number)
  end

  on(CapitalAssetInformationProcessingPage).process
end

And /^I create asset from General Ledger Processing$/ do
  on(GeneralLedgerProcessingPage).create_asset
  @asset_global = create AssetGlobalObject
  sleep 3
  @new_asset_number = on(AssetGlobalPage).asset_number
end

Given  /^I create a Distribution of Income and Expense document with the following:$/ do |table|
  account_info = table.raw.flatten.each_slice(6).to_a
  account_info.shift # skip header row
  capital_asset_action = 'No'

  steps %Q{
            Given   I am logged in as a KFS User for the DI document
            And     I start an empty Distribution Of Income And Expense document
          }

  account_info.each do |line_type, chart_code, account_number, object_code, amount, capital_asset|
    account_amount = !@lookup_asset.nil? && amount.empty? ? @asset_amount : amount
    account_line_type = line_type.eql?('From') ? 'Source' : 'Target'
    capital_asset_action = line_type.eql?('From') && !capital_asset.empty? && capital_asset.eql?('Yes') ? 'modify' : 'No'
    capital_asset_action = capital_asset_action.eql?('No') && line_type.eql?('To') && !capital_asset.empty? && capital_asset.eql?('Yes') ? 'create' : 'No'
    step "I add a #{account_line_type} Accounting Line to the Distribution Of Income And Expense document with the following:",
         table(%Q{
              | Chart Code   | #{chart_code}       |
              | Number       | #{account_number}   |
              | Object Code  | #{object_code}      |
              | Amount       | #{account_amount}           |
         })
  end

  unless @lookup_asset.nil?
    capital_asset_action = capital_asset_action.eql?('create') ? 'move' : 'modify'
    step "I add a Source Accounting Line to the Distribution Of Income And Expense document with the following:",
         table(%Q{
              | Chart Code   | #{@asset_chart}            |
              | Number       | #{@modify_asset_account_number}   |
              | Object Code  | #{@asset_object_code}      |
              | Amount       | #{@asset_amount}           |
         })

  end
  case capital_asset_action
    when 'create'
      steps %Q{
              And     I select accounting line #1 and create Capital Asset
              And     I distribute a new Capital Asset amount
              And     I add a tag and location for Capital Asset
  }
    when 'modify'
      steps %Q{
              And   I select accounting line #1 and modify Capital Asset
              And     I distribute the modify Capital Asset amount
  }
    when 'move'
      steps %Q{
              And     I select accounting line #1 and create Capital Asset
              And     I distribute a new Capital Asset amount
              And     I add a tag and location for Capital Asset
              And     I select accounting line #2 and modify Capital Asset
              And     I distribute the modify Capital Asset amount
  }
  end

  steps %Q{
            And     I submit the Distribution Of Income And Expense document
            And     the Distribution Of Income And Expense document goes to ENROUTE
            And     I route the Distribution Of Income And Expense document to final
          }

end

And /^I lookup a Capital Asset with the following:$/ do |table|
  asset_info = table.rows_hash
  visit(MainPage).asset
  on AssetLookupPage do |page|
    page.campus.fit asset_info['Campus']
    page.building_code.fit asset_info['Building']
    page.building_room_number.fit asset_info['Room']
    page.asset_type_code.fit asset_info['Asset Type']
    page.asset_status_code.fit asset_info['Asset Code']
    page.search
    page.return_random_asset
    #  TODO slow to return. need to find more efficient to pick return asset
  end
end

And /^I select Capital Asset detail information$/ do
  on AssetInquiryPage do |page|
    page.toggle_payment
    @asset_number = page.asset_number
    @modify_asset_account_number = page.asset_account_number
    @asset_object_code = page.asset_object_code
    @asset_amount = page.asset_amount
    @asset_chart = page.asset_chart
    @lookup_asset = 'Yes'
  end

end

And /^I modify a Capital Asset from the General Ledger and apply payment$/ do
  step 'I Login as an Asset Processor'
  step "I lookup a Capital Asset with Account Number of #{@modify_asset_account_number} from GL transaction to process"
  step 'I select and apply payment for General Ledger Capital Asset'
  step 'I submit the Asset Manual Payment document'
  step 'the Asset Manual Payment document goes to FINAL'
  step "check payments tab for correct account and amount with following:",
       table(%Q{
              | Asset Number    | #{@asset_number}            |
              | Account Number  | #{@modify_asset_account_number}   |
              | Amount          | #{@asset_amount}           |
         })
end

And /^I select and apply payment for General Ledger Capital Asset$/ do
  on(GeneralLedgerProcessingPage).apply_payment
  @asset_manual_payment = create AssetManualPaymentObject
end

Given  /^I create a Distribution of Income and Expense document with target account using a non Capital Asset account and the same Capital Asset Object Code$/ do
  account_nbr = get_account_of_type('Endowed Appropriated')
  chart_code = get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)

  step 'I create a Distribution of Income and Expense document with the following:',
       table(%Q{
      | Line Type | Chart Code     | Account        | Object Code            | Amount | Capital Asset? |
      | To        | #{chart_code}  | #{account_nbr} | #{@asset_object_code}  |        | Yes            |
         })

end

And /^check payments tab for correct account and amount with following:$/ do |table|
  arguments = table.rows_hash
  visit(MainPage).asset
  on AssetLookupPage do |page|
    page.asset_number.fit arguments['Asset Number']
    page.search
    page.return_random_asset
  end

  on AssetInquiryPage do |page|
    page.toggle_payment
    i = page.current_payment_count - 1
    page.asset_account_number(i).should == arguments['Account Number']
    page.asset_amount(i).gsub(',','').should include arguments['Amount'].gsub(',','')
  end

end