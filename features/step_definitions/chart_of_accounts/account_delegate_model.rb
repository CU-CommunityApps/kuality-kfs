When /^I (.*) an Account Delegate Model document with an invalid Organization Code$/ do |button|
  @account_delegate_model = create AccountDelegateModelObject, organization_code: generate_invalid_organization_code
  step "I #{button} the Account Delegate Model document"
end
