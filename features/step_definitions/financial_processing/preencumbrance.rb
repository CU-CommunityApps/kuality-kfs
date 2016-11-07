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

