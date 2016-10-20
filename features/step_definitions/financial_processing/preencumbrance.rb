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


When /^I (#{PreEncumbrancePage::available_buttons}) a Pre\-Encumbrance Document that encumbers the random Account$/ do |button|
  # Note: You must have created a random account object in a previous step to use this step.
  # Note: This step WILL CREATE the random object code object and will use the parameter default source amount.
  step "I find a random Pre-Encumbrance Object Code"
  @encumbrance_amount = get_aft_parameter_value(ParameterConstants::DEFAULT_PREENCUMBRANCE_SOURCE_ACCOUNTING_LINE_AMOUNT)
  @pre_encumbrance = create PreEncumbranceObject,
                            initial_lines: [{
                                                type:              :source,
                                                account_number:    @account.number,
                                                chart_code:        @account.chart_code,
                                                object:            @object_code.object_code,
                                                amount:            @encumbrance_amount,
                                                line_description:  'Using previously created random account'
                                            }]
  step "I save the Pre-Encumbrance document"   # pre-encumbrance document must be saved before it can be submitted
  step "I #{button} the Pre-Encumbrance document"
  step 'I add the encumbrance to the stack'
end

When /^I (#{PreEncumbrancePage::available_buttons}) a Pre-Encumbrance document that encumbers a random Account$/ do |button|
  #Note: This step WILL CREATE the random account object and random object code object, and will use the parameter pre-encumbrance source amount.
  step "I find a random Pre-Encumbrance Account"
  step "I find a random Pre-Encumbrance Object Code"
  @encumbrance_amount = get_aft_parameter_value(ParameterConstants::DEFAULT_PREENCUMBRANCE_SOURCE_ACCOUNTING_LINE_AMOUNT)
  @pre_encumbrance = create PreEncumbranceObject,
                            initial_lines: [{
                                                type:              :source,
                                                account_number:    @account.number,
                                                chart_code:        @account.chart_code,
                                                object:            @object_code.object_code,
                                                amount:            @encumbrance_amount,
                                                line_description:  'Created random account and object code'
                                            }]
  step "I save the Pre-Encumbrance document"   # pre-encumbrance document must be saved before it can be submitted
  step "I #{button} the Pre-Encumbrance document" unless button.eql?('save')   # do not save a second time when step was requested to save
  step 'I add the encumbrance to the stack'
end


Then /^the outstanding encumbrance for the account and object code used is the difference between the amounts$/ do
  # Note: You must have created a random account object in a previous step to use this step.
  # Note: You must have created a random object code object in a previous step to use this step.
  # Note: You must have created the encumbrance amount in a previous step to use this step.
  # Note: You must have created the disencumbrance amount object in a previous step to use this step.
  visit(MainPage).open_encumbrances
  on OpenEncumbranceLookupPage do |page|
    page.account_number.set     @account.number
    page.chart_code.set         @account.chart_code
    page.object_code.set        @object_code.object_code
    page.including_pending_ledger_entry_approved.set
    page.doc_number.set         @remembered_document_id
    page.balance_type_code.set 'PE'
    page.search
    page.wait_for_search_results

    # before comparing deal with the possibility of money with no cents and compare the same data type of integer
    computed_outstanding_amount = ((@encumbrance_amount.to_f - @disencumbrance_amount.to_f) * 100).to_i
    outstanding_amount_col = page.column_index(:outstanding_amount)
    page_outstanding_amount = (((page.results_table.rest[0][outstanding_amount_col].text.groom).to_f) * 100).to_i
    page_outstanding_amount.should == computed_outstanding_amount
  end
end


And /^I add a target Accounting Line to the Pre-Encumbrance document that matches the source Accounting Line except for amount$/ do
  # Note: You must have captured the source account object and object code object in a previous step to use this step.
  @disencumbrance_amount = get_aft_parameter_value(ParameterConstants::DEFAULT_PREENCUMBRANCE_TARGET_ACCOUNTING_LINE_AMOUNT)
  step "I add a target Accounting Line for chart code #{@account.chart_code} and account number #{@account.number} and object code #{@object_code.object_code} and amount #{@disencumbrance_amount} to the Pre-Encumbrance document"
end


And /^I add a source Accounting Line to a Pre-Encumbrance document that automatically disencumbers an account with an existing encumbrance by a partial amount using a fixed monthly schedule$/ do
  parameter_to_use = ParameterConstants::DEFAULTS_FOR_PREENCUMBRANCE_AUTOMATIC_PARTIAL_DISENCUMBRANCE
  step "I obtain #{parameter_to_use} data values required for the test from the Parameter table"
  #do not continue if input data required for next step in test was not specified in the Parameter table
  fail ArgumentError, "Parameter #{parameter_to_use} required for this test does not exist in the Parameter table." if @test_input_data.nil? || @test_input_data.empty?
  fail ArgumentError, "Parameter #{parameter_to_use} does not specify required input test data value for auto disencumber type" if @test_input_data[:auto_disencumbrance_type].nil? || @test_input_data[:auto_disencumbrance_type].empty?
  fail ArgumentError, "Parameter #{parameter_to_use} does not specify required input test data value for count" if @test_input_data[:count].nil? || @test_input_data[:count].empty?
  fail ArgumentError, "Parameter #{parameter_to_use} does not specify required input test data value for partial_amount" if @test_input_data[:partial_amount].nil? || @test_input_data[:partial_amount].empty?
  # global encumbrance data item should have been set by a previous step
  @disencumbrance_amount = @encumbrance_amount
  # partial amount could be money with decimal, count should be a whole number,
  # NOTE: If string compares are performed in steps, recommend converting to cents first and then doing the compare
  @encumbrance_amount = (((@test_input_data[:partial_amount]).to_f * 100) * (@test_input_data[:count]).to_i) / 100

  step "I add a Source Accounting Line to the Pre-Encumbrance document with the following:",
       table = table(%Q{
              | Chart Code                | #{@account.chart_code}                         |
              | Number                    | #{@account.number}                             |
              | Object Code               | #{@object_code.object_code}             |
              | Amount                    | #{@encumbrance_amount}                         |
              | Auto Disencumber Type     | #{@test_input_data[:auto_disencumbrance_type]} |
              | Partial Transaction Count | #{@test_input_data[:count]}                    |
              | Partial Amount            | #{@test_input_data[:partial_amount]}           |
              | Start Date                | #{right_now[:date_w_slashes]}                  |
           })
end


And /^I add a target Accounting Line to a Pre-Encumbrance document to disencumber an existing encumbrance$/ do
  step "I add a Target Accounting Line to the Pre-Encumbrance document with the following:",
       table = table(%Q{
              | Chart Code       | #{@account.chart_code}             |
              | Number           | #{@account.number}                 |
              | Object Code      | #{@object_code.object_code} |
              | Amount           | #{@disencumbrance_amount}          |
              | Reference Number | #{@remembered_document_id}         |
           })
end


And /^I add a (source|target) Accounting Line for chart code (.*) and account number (.*) and object code (.*) and amount (.*) to the (.*) document$/ do |line_type, chart_code, account_number, object_code, amount, document|
  line_data_as_table = nil
  if line_type.eql?('source')
    line_data_as_table = table(%Q{
              | Chart Code  | #{chart_code}      |
              | Number      | #{account_number}  |
              | Object Code | #{object_code}     |
              | Amount      | #{amount}          |
           })
  elsif line_type.eql?('target')
    line_data_as_table = table(%Q{
              | Chart Code       | #{chart_code}              |
              | Number           | #{account_number}          |
              | Object Code      | #{object_code}             |
              | Amount           | #{amount}                  |
              | Reference Number | #{@remembered_document_id} |
           })
  end
  step "I add a #{line_type.capitalize} Accounting Line to the #{document} document with the following:", line_data_as_table
end


And /^I add a (source|target) Accounting Line with a random account, a random object code and a default amount to the (.*) document$/ do |line_type, document|
  amount = nil
  case
    when line_type.eql?('source')
      @encumbrance_amount = get_aft_parameter_value(ParameterConstants::DEFAULT_PREENCUMBRANCE_SOURCE_ACCOUNTING_LINE_AMOUNT)
      #fail the test if required parameter is not set
      @encumbrance_amount.nil?.should_not == true
      amount = @encumbrance_amount
    when line_type.eql?('target')
      @disencumbrance_amount = get_aft_parameter_value(ParameterConstants::DEFAULT_PREENCUMBRANCE_TARGET_ACCOUNTING_LINE_AMOUNT)
      #fail the test if required parameter is not set
      @disencumbrance_amount.nil?.should_not == true
      amount = @disencumbrance_amount
  end
  step "I find a random Pre-Encumbrance Account"
  step "I find a random Pre-Encumbrance Object Code"
  step "I add a #{line_type} Accounting Line for chart code #{@account.chart_code} and account number #{@account.number} and object code #{@object_code.object_code} and amount #{amount} to the #{document} document"
end

