When /^I tab away from the Account Number field$/ do
  on SubAccountPage do |page|
    page.account_number.select
    page.account_number.send_keys :tab
  end
end

Then /^The Indirect Cost Rate ID field should not be null$/ do
  on(SubAccountPage).icr_identifier.value.should == ''
end

And /^I am logged in as the FO of the Account$/ do
  sleep(1)
  step "I am logged in as \"#{@account.accountFiscalOfficerUser.principalName}\""
  @user_id = @account.accountFiscalOfficerUser.principalNam
end

And /^I am logged in as the FO of the Sub-Account$/ do
  sleep(1)
  account_info = get_kuali_business_object('KFS-COA','Account',"accountNumber=#{@sub_account.account_number}")
  fiscal_officer_principal_name = account_info['accountFiscalOfficerUser.principalName'][0]
  step "I am logged in as \"#{fiscal_officer_principal_name}\""
  @user_id = fiscal_officer_principal_name
end

And /^The Sub-Account document should be in my action list$/ do
  sleep(5)
  on ActionList do |page|
    page.view_as(@user_id)
    page.last if on(ActionList).last_link.exists?
    page.result_item(@sub_account.document_id).should exist
  end
end

And /^I lookup the Sub-Account I want to edit$/ do
  #get the sub-account we want to edit
  visit(MainPage).sub_account
  on SubAccountLookupPage do |page|
    page.chart_code.fit           @sub_account.chart_code
    page.account_number.fit       @sub_account.account_number
    page.sub_account_number.fit   @sub_account.sub_account_number
    page.search
    # sub_account_number could be an alpha-numeric, Watir is not able to find the item in the table of values
    # returned by the lookup unless the sub_account_number matches even on case of letters (i.e. aBc != ABC)
    page.edit_item(@sub_account.sub_account_number.upcase)
  end
end