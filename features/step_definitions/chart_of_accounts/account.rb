And /^I copy an Account$/ do
  on(AccountLookupPage).copy_random
  on AccountPage do |page|
    page.description.fit 'AFT testing copy'
    page.chart_code.fit get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
    page.number.fit random_alphanums(4, 'AFT')
    @account = make AccountObject
    @account.chart_code = page.chart_code.text
    @account.number = page.number.text
    @account.description = page.description
    @account.document_id = page.document_id
    @document_id = page.document_id
    page.save
    page.left_errmsg_text.should include 'Document was successfully saved.'
  end
end

And /^I save an Account with a lower case Sub Fund Program$/ do
  @account = create AccountObject, sub_fund_group_code: 'board', press: :save
end

When /^I submit an account with blank SubFund group Code$/ do
  @account = create AccountObject, sub_fund_group_code: '', press: :submit
end

Then /^I should get an error on saving that I left the SubFund Group Code field blank$/ do
  on(AccountPage).errors.should include 'Sub-Fund Group Code (SubFundGrpCd) is a required field.'
end

Then /^the Account Maintenance Document saves with no errors$/  do
  on(AccountPage).document_status.should == 'SAVED'
end

Then /^the Account Maintenance Document has no errors$/  do
  on(AccountPage).document_status.should == 'ENROUTE'
end

And /^I edit an Account with a Sub-Fund Group Code of (.*)/ do |sub_fund_group_code|
  visit(MainPage).account
  on AccountLookupPage do |page|
    page.sub_fund_group_code.fit sub_fund_group_code
    page.search
    page.edit_random
  end
end

And /^I edit an Account$/ do
  visit(MainPage).account
  on AccountLookupPage do |page|
    page.search
    page.edit_random
  end
  on AccountPage do |page|
    @account = make AccountObject
    page.description.set @account.description
    @account.document_id = page.document_id
    @account.absorb! :old
    @account.absorb! :new
  end
end

And /^I enter Sub Fund Group Code of (.*)/ do |sub_fund_group_code|
  on(AccountPage).sub_fund_group_code.set sub_fund_group_code
end

And /^I close the Account$/ do
  random_continuation_account_number = @account.number
  visit(MainPage).account
  on AccountLookupPage do |page|
    # First, let's get a random continuation account
    begin
      random_continuation_account_number = page.get_random_account_number
    end while random_continuation_account_number == @account.number

    # Now, let's try to close that account
    page.chart_code.fit     @account.chart_code
    page.account_number.fit @account.number
    page.closed_no.set # There's no point in doing this if the account is already closed. Probably want an error, if a search with this setting fails.
    page.search
    page.edit_random # should only select the guy we want, after all
  end
  @account.edit description:                 "Closing Account #{@account.number}",
                continuation_account_number: random_continuation_account_number,
                continuation_chart_code:     get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE_WITH_NAME),
                account_expiration_date:     on(AccountPage).effective_date.value,
                closed:                      :set
end

And /^I edit the Account$/ do
  visit(MainPage).account
  on AccountLookupPage do |page|
    page.chart_code.fit @account.chart_code
    page.account_number.fit @account.number
    page.search
    page.edit_random
  end
  on AccountPage do |page|
    page.description.fit 'AFT testing edit'
    @account.description = 'AFT testing edit'
    @account.document_id = page.document_id
  end
end

And /^I enter a Continuation Chart Of Accounts Code that equals the Chart of Account Code$/ do
  on(AccountPage) { |page| page.continuation_chart_code.fit page.chart_code.text }
end

And /^I enter a Continuation Account Number that equals the Account Number$/ do
  @account.edit continuation_account_number: on(AccountPage).account_number_old
end

And /^I clone a random Account with the following changes:$/ do |table|
  step 'I clone Account nil with the following changes:', table
end

And /^I extend the Expiration Date of the Account document (\d+) days$/ do |days|
  @account.edit account_expiration_date: (@account.account_expiration_date + days.to_i).strftime('%m/%d/%Y')
end

And /^I clone a random Account with name, chart code, and description changes$/ do
  step 'I clone Account nil with the following changes:',
       table(%Q{
         | Name        | #{random_alphanums(15, 'AFT')}                                      |
         | Chart Code  | #{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}  |
         | Description | #{random_alphanums(40, 'AFT')}                                      |
       })
end

And /^I edit an Account with a random Sub-Fund Group Code$/ do
  visit(MainPage).account
  on AccountLookupPage do |page|
    page.chart_code.fit get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
    page.account_number.fit get_account_of_type('Random Sub-Fund Group Code')
    page.search
    page.edit_random
  end
  on AccountPage do |page|
    @account = make AccountObject
    page.description.set @account.description
    @account.absorb! :old
    @account.absorb! :new
  end
end

And /^I create an Account and leave blank for the fields of Guidelines and Purpose tab$/ do
  @account = create AccountObject, expense_guideline_text: '',
                                   income_guideline_text:  '',
                                   purpose_text:           '',
                                   press:                  nil
end

And /^the Account document's Sub Fund Program code is uppercased$/ do
  on(AccountPage).sub_fund_group_code_new.should == @account.sub_fund_group_code.upcase
  @account.sub_fund_group_code = on(AccountPage).sub_fund_group_code_new # Grab the update, if necessary
end

And /^I find a random Pre-Encumbrance Account Object$/ do
  # This step will make a global account object by calling the web service that obtains an account that can be used
  # for a pre-encumbrance.
  random_attributes_hash = Hash.new
  random_attributes_hash = AccountObject.webservice_item_to_hash(get_random_account_for_pre_encumbrance)
  @account = make AccountObject, random_attributes_hash
  step "I add the account to the stack"
end