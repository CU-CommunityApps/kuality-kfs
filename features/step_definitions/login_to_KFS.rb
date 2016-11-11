Given /^I am logged in as a KFS Operations$/ do
  perform_backdoor_login(get_first_principal_name_for_role('KFS-SYS', 'Operations'))
end

Given /^I am logged in as a KFS Fiscal Officer$/ do
  perform_backdoor_login(get_aft_parameter_value(ParameterConstants::DEFAULT_FISCAL_OFFICER))
end

Given /^I am logged in as a KFS User$/ do
  perform_backdoor_login(get_random_principal_name_for_role('KFS-SYS', 'User'))
end

Given /^I am logged in as "([^"]*)"$/ do |user_id|
  perform_backdoor_login(user_id)
end

Given /^I am logged in as a KFS Chart Manager$/ do
  perform_backdoor_login(get_random_principal_name_for_role('KFS-SYS', 'Chart Manager'))
end

Given /^I am logged in as a KFS Chart Administrator$/ do
  perform_backdoor_login(get_random_principal_name_for_role('KFS-SYS', 'Chart Administrator (cu)'))
end

Given /^I am logged in as a KFS Contracts & Grants Manager$/ do
  perform_backdoor_login(get_random_principal_name_for_role('KFS-SYS', 'Contracts & Grants Manager'))
end

Given /^I am logged in as a KFS User for the (.*) document$/ do |eDoc|
  perform_backdoor_login(get_document_initiator(eDoc))
end

Given /^I am logged in as a Labor Distribution Manager$/ do
  perform_backdoor_login(get_first_principal_name_for_role('KFS-LD', 'Labor Distribution Manager (cu)'))
end

# This Cucumber step takes the User principal name so the application login can be performed as that user.
Given  /^I am User (.*) who is a Salary Transfer Initiator$/ do |principal_name|
  perform_backdoor_login(principal_name)
end

Given /^I Login as an Asset Processor$/ do
  perform_backdoor_login(get_first_principal_name_for_role('KFS-SYS', 'Asset Processor'))
end

And /^I remember the logged in user$/ do
  @remembered_logged_in_user = get_current_user
end

And /^I am logged in as the remembered user$/ do
  perform_backdoor_login(@remembered_logged_in_user)
end

Given /^I am logged in as a KFS User who is not a Contracts & Grants Processor$/ do
  kfs_users = get_principal_name_for_role('KFS-SYS', 'User')
  cg_processors = get_principal_name_for_role('KFS-SYS', 'Contracts & Grants Processor')
  kfs_users_who_are_not_cd_processors = kfs_users - cg_processors
  perform_backdoor_login(kfs_users_who_are_not_cd_processors.sample)
end
