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
  end
  step "I save the Account document"
end

And /^I save an Account with a lower case Sub Fund Program$/ do
  @account = create AccountObject, sub_fund_group_code: 'board'
  step "I save the Account document"
end

Then /^the Account Maintenance Document saves with no errors$/  do
  step 'The document should save successfully'
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
    page.wait_for_search_results
    page.edit_random
  end
  on AccountPage do |page|
    @account = make AccountObject
    page.description.set @account.description
    @account.absorb! :old
    @account.absorb! :new
  end
end

And /^the Account document's Sub Fund Program code is uppercased$/ do
  on(AccountPage).sub_fund_group_code_new.should == @account.sub_fund_group_code.upcase
  @account.sub_fund_group_code = on(AccountPage).sub_fund_group_code_new # Grab the update, if necessary
end

And /^I find a random Pre-Encumbrance Account$/ do
  random_attributes_hash = Hash.new
  random_attributes_hash = AccountObject.webservice_item_to_hash(get_random_account_for_pre_encumbrance)
  @account = make AccountObject, random_attributes_hash
  step "I add the account to the stack"
end

When /^I enter a Sub-Fund Program Code of (.*)$/ do |sub_fund_program_code|
  on AccountPage do |page|
    page.subfund_program_code.set sub_fund_program_code
    @account.subfund_program_code = sub_fund_program_code
  end
  step 'I save the Account document'
  step 'I add the account to the stack'
end

When /^I enter (.*) as an invalid Major Reporting Category Code$/  do |major_reporting_category_code|
  on AccountPage do |page|
    page.major_reporting_category_code.fit major_reporting_category_code
    page.save
    @account.major_reporting_category_code = major_reporting_category_code
  end
  step 'I add the account to the stack'
end

When /^I enter (.*) as an invalid Appropriation Account Number$/  do |appropriation_account_number|
  on AccountPage do |page|
    page.appropriation_account_number.fit appropriation_account_number
    @account.appropriation_account_number = appropriation_account_number
  end
  step 'I save the Account document'
  step 'I add the account to the stack'
end

When /^I save an Account document with only the ([^"]*) field populated$/ do |field|
  # TODO: Swap this out for Account#defaults
  default_fields = {
      description:          random_alphanums(40, 'AFT'),
      chart_code:           get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE),
      number:               random_alphanums(7),
      name:                 random_alphanums(10),
      organization_code:    '01G0',#TODO config?
      campus_code:          get_aft_parameter_value(ParameterConstants::DEFAULT_CAMPUS_CODE),
      effective_date:       '01/01/2010',
      postal_code:          get_random_postal_code('*'),
      city:                 get_generic_city,
      state:                get_random_state_code,
      address:              get_generic_address_1,
      type_code:            get_aft_parameter_value(ParameterConstants::DEFAULT_CAMPUS_TYPE_CODE),
      sub_fund_group_code:  'ADMSYS',#TODO config?
      higher_ed_funct_code: '4000',#TODO config?
      restricted_status_code:     'U - Unrestricted',#TODO config?
      fo_principal_name:          get_aft_parameter_value(ParameterConstants::DEFAULT_FISCAL_OFFICER),
      supervisor_principal_name:  get_aft_parameter_value(ParameterConstants::DEFAULT_SUPERVISOR),
      manager_principal_name: get_aft_parameter_value(ParameterConstants::DEFAULT_MANAGER),
      budget_record_level_code:   'C - Consolidation',#TODO config?
      sufficient_funds_code:      'C - Consolidation',#TODO config?
      expense_guideline_text:     'expense guideline text',
      income_guideline_text: 'incomde guideline text',
      purpose_text:         'purpose text',
      labor_benefit_rate_cat_code: 'CC'#TODO config?
  }

  # TODO: Make the Account document creation with a single field step more flexible.
  case field
    when 'Description'
      default_fields.each {|k, _| default_fields[k] = '' unless k.to_s.eql?('description') }
  end

  @account = create AccountObject, default_fields
  step 'I save the Account document'
  step 'I add the account to the stack'
end

When /^I enter an invalid (.*)$/  do |field_name|
  case field_name
    when 'Sub-Fund Program Code'
      step "I enter a Sub-Fund Program Code of #{random_alphanums(4, 'XX').upcase}"
    when 'Major Reporting Category Code'
      step "I enter #{random_alphanums(6, 'XX').upcase} as an invalid Major Reporting Category Code"
    when 'Appropriation Account Number'
      step "I enter #{random_alphanums(6, 'XX').upcase} as an invalid Appropriation Account Number"
  end
end

Then /^I should get (invalid|an invalid) (.*) errors?$/ do |invalid_ind, error_field|
  on AccountPage do |page|
    case error_field
      when 'Sub-Fund Program Code'
        page.errors.should include "Sub-Fund Program Code #{page.subfund_program_code.value} is not associated with Sub-Fund Group Code #{page.sub_fund_group_code.value}."
      when 'Major Reporting Category Code'
        page.errors.should include "Major Reporting Category Code (#{page.major_reporting_category_code.value}) does not exist."
      when 'Appropriation Account Number'
        page.errors.should include "Appropriation Account Number #{page.appropriation_account_number.value} is not associated with Sub-Fund Group Code #{page.sub_fund_group_code.value}."
    end
  end
end

And /^I enter (Sub Fund Program Code|Sub Fund Program Code and Appropriation Account Number) that (is|are) associated with a random Sub Fund Group Code$/ do |codes, is_are|
  account = get_kuali_business_object('KFS-COA','Account','subFundGroupCode=*&extension.programCode=*&closed=N&extension.appropriationAccountNumber=*&active=Y&accountExpirationDate=NULL')
  on AccountPage do |page|
    page.sub_fund_group_code.set account['subFundGroup.codeAndDescription'].sample.split('-')[0].strip
    page.subfund_program_code.set account['extension.programCode'].sample
    @account.sub_fund_group_code = page.sub_fund_group_code_new
    @account.subfund_program_code = page.subfund_program_code_new
    unless codes == 'Sub Fund Program Code'
      page.appropriation_account_number.set account['extension.appropriationAccountNumber'].sample
      @account.appropriation_account_number = page.appropriation_account_number_new
    end
  end
end

When /^I input a lowercase Major Reporting Category Code value$/  do
  major_reporting_category_code = get_kuali_business_object('KFS-COA','MajorReportingCategory','active=Y')['majorReportingCategoryCode'].sample
  on(AccountPage).major_reporting_category_code.fit major_reporting_category_code.downcase
  @account.major_reporting_category_code = major_reporting_category_code.downcase
end

And /^I enter an Appropriation Account Number that is not associated with the Sub Fund Group Code$/  do
  # the account# is not used as its own appropriation account#
  on AccountPage do |page|
    page.appropriation_account_number.fit page.account_number_old
    @account.appropriation_account_number = page.appropriation_account_number_new
  end
end

And /^I clone Account (.*) with the following changes:$/ do |account_number, table|
  step 'I remember the logged in user'
  unless account_number.empty?
    # Use webservice call to get random account number as it is faster than doing account lookup search for all accounts
    account_number = (account_number == 'nil') ? get_random_account_number : account_number
    updates = table.rows_hash
    updates.delete_if { |k,v| v.empty? }
    updates['Indirect Cost Recovery Active Indicator'] = updates['Indirect Cost Recovery Active Indicator'].to_sym unless updates['Indirect Cost Recovery Active Indicator'].nil?

    visit(MainPage).account
    on AccountLookupPage do |page|
      page.chart_code.fit     get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
      page.account_number.fit account_number
      page.search
      page.wait_for_search_results
      page.copy_random
    end
    on AccountPage do |page|
      @document_id = page.document_id
      new_account_number = (random_alphanums(7)).upcase! #need to ensure data in object matches page since page auto uppercases this value
      @account = make AccountObject, description: updates['Description'],
                      name:        updates['Name'],
                      chart_code:  updates['Chart Code'],
                      number:      new_account_number,
                      document_id: page.document_id

      page.description.fit               @account.description
      page.name.fit                      @account.name
      page.chart_code.fit                @account.chart_code
      page.number.fit                    @account.number
      page.supervisor_principal_name.fit @account.supervisor_principal_name
      #only attempt data entry for ICR tab when all the required ICR data is provided
      if updates['Indirect Cost Recovery Chart Of Accounts Code'] && updates['Indirect Cost Recovery Account Number'] &&
          updates['Indirect Cost Recovery Account Line Percent'] && updates['Indirect Cost Recovery Active Indicator']
        @account.icr_accounts.add chart_of_accounts_code: updates['Indirect Cost Recovery Chart Of Accounts Code'],
                                  account_number:         updates['Indirect Cost Recovery Account Number'],
                                  account_line_percent:   updates['Indirect Cost Recovery Account Line Percent'],
                                  active_indicator:       updates['Indirect Cost Recovery Active Indicator']
      end

      page.errors.should == []  #fail the test and do not continue if errors exist on page after performing data changes
    end

    step 'I submit the Account document'
    step 'the document should have no errors'
    step 'I route the Account document to final'
    step 'I add the account to the stack'
    step 'I am logged in as the remembered user'
  end
end

And /^I add the account to the stack$/ do
  @accounts = @accounts.nil? ? [@account] : @accounts + [@account]
end

And /^I create an Account using a CG account with a CG Account Responsibility ID in range (.*) to (.*)$/ do |lower_limit, upper_limit|
  #method call should return an array
  account_numbers = find_cg_accounts_in_cg_responsibility_range(lower_limit, upper_limit)

  options = {
      chart_code:               get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE),
      account_number:           account_numbers.sample,
      name:                     'Test create Account with CG account',
  }
  @account = create AccountObject, options
  @account.icr_accounts.updates_pulled_from_page :new

end

And /^I edit an Account having a CG account with a CG Account Responsibility ID in range (.*) to (.*)$/ do |lower_limit, upper_limit|
  #method call should return an array
  account_numbers = find_cg_accounts_in_cg_responsibility_range(lower_limit, upper_limit)

  visit(MainPage).account
  on AccountLookupPage do |page|
    page.chart_code.fit      get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
    page.account_number.fit  account_numbers.sample
    page.search
    page.wait_for_search_results
    page.edit_random
  end
  on AccountPage do |page|
    @account = make AccountObject
    page.description.set @account.description
    @account.absorb! :new
  end
end

And /^I submit the Account document addressing Continutaion Account errors$/ do
  # Editting an existing account could cause business rule error that continuation account is closed or expired
  # upon submit. When those business rule errors occur, edit the continuation account on the account to the default
  # continutation account parameter value.
  step 'I submit the Account document'

  #getting errors from page is expensive, obtain reference once that can be reused
  page_errors = $current_page.errors
  #search errors array for Continuation Account in any of the error messages
  continuation_acct_error_exists = page_errors.any? { |s| s.include?('Continuation Account') }
  if continuation_acct_error_exists
    on AccountPage do |page|
      #update the account object with changes and then use that object to edit the page
      @account.continuation_chart_code = get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
      @account.continuation_account_number = get_aft_parameter_value(ParameterConstants::DEFAULT_CONTINUATION_ACCOUNT_NUMBER)
      page.continuation_chart_code.fit @account.continuation_chart_code
      page.continuation_account_number.fit @account.continuation_account_number
    end
    #attempt submit again, it should work this time, if it doesn't, there is some other business rule issue
    step 'I submit the Account document'
    step 'the document should have no errors'
  end
end

And /^I edit the first active Indirect Cost Recovery Account on the Account to (a|an) (closed|open)(?: (.*))? Contracts & Grants Account$/ do |a_an_ind, open_closed_ind, expired_non_expired_ind|
  # do not continue, fail the test if there there is no icr_account to edit
  fail ArgumentError, 'No Indirect Cost Recovery Account exists on the Account. Cannot continue with scenario because data cannot be modified as requested. ' if @account.icr_accounts.length == 0

  random_account_number = find_random_cg_account_number_having(open_closed_ind, expired_non_expired_ind)

  fail ArgumentError, "Cannot edit ICR Account on the Account, WebService call did not return requested '#{open_closed_ind} #{expired_non_expired_ind} Contacts & Grants Acccount' required for this test." if random_account_number.nil? || random_account_number.empty?

  # Need to find first active ICR account as an inactive one could be anywhere in collection
  i = 0
  index_to_use = -1
  while i < @account.icr_accounts.length and index_to_use == -1
    if @account.icr_accounts[i].active_indicator == :set
      index_to_use = i
    end
    i+=1
  end

  fail ArgumentError, "No active ICR Account on the Account for editting" if index_to_use == -1

  # add values for the specified keys being edited for this single ICR account
  options = {
      account_number:         random_account_number,
      chart_of_accounts_code: get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
  }

  @account.icr_accounts[index_to_use].edit options
end

When /^I add a closed Contacts & Grants Account as the 100 percent Indirect Cost Recovery Account to the Account$/ do
  #attempt to add a closed C&G account should create an error message on the page that needs to be verified by the caller

  #method being called requires two parameters but no data is needed when first parameter is 'closed'
  random_account_number = find_random_cg_account_number_having('closed', '')

  fail ArgumentError, "Cannot add ICR Account for Account, WebService call did not return requested 'closed Contacts & Grants Acccount' required for this test." if random_account_number.nil? || random_account_number.empty?

  @account.icr_accounts.add chart_of_accounts_code: get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE),
                            account_number:         random_account_number,
                            account_line_percent:   '100',
                            active_indicator:       :set
end
