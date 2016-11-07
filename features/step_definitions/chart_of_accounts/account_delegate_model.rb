When /^I (.*) an Account Delegate Model document with an invalid Organization Code$/ do |button|
  @account_delegate_model = create AccountDelegateModelObject, organization_code: 'BSBS'
  step "I #{button} the Account Delegate Model document"
end
