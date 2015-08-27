And /^I edit the Active To Date on a random Organization Review to today's date$/ do
  visit(MainPage).organization_review
  on OrganizationReviewLookupPage do |page|
    page.chart_code.fit   get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE_WITH_NAME)
    page.search
    page.wait_for_search_results
    page.edit_random
  end
  on OrganizationReviewPage do |page|
    #Only data we are adding/modifying in this step, rest of the values come from the edit action just performed.
    page.description.fit    'AFT OrganizationReview Edit'
    page.active_to_date.fit right_now[:date_w_slashes] #Cannot be back dated, Use today as the current date

    #Now obtain all the data values from the page and use them to make our backing object
    document_attributes_hash = {
        :document_id                    => page.document_id,
        :initiator                      => page.initiator,
        :description                    => page.description_new
    }.merge(page.organization_review_data_new)

    #Get all the data values from the page and use them to make our backing object.
    @organization_review = make OrganizationReviewObject, document_attributes_hash
  end
end


And /^I copy a random Organization Review changing Organization Code to a random value$/ do
  visit(MainPage).organization_review
  on OrganizationReviewLookupPage do |page|
    page.chart_code.fit   get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE_WITH_NAME)
    page.search
    page.wait_for_search_results
    page.copy_random
  end
  on OrganizationReviewPage do |page|
    # Only data we are adding/modifying for this step is description and organization code.
    # Rest of the values come from the copy action just performed.
    page.description.fit    'AFT OrganizationReview Copy'

    #Now get a new Organization Code value from the lookup
    page.organization_code_search
    on OrganizationLookupPage do |org_cd_page|
      org_cd_page.chart_code.fit            get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
      org_cd_page.organization_code.fit     ""   #clear this value for our search
      org_cd_page.active_indicator_yes.set
      org_cd_page.search
      org_cd_page.wait_for_search_results
      org_cd_page.return_random
    end

    # Copy action copies an existing Organization Review forward which may cause the Active From Date or
    # Active To Date to be back dated.  Ensure these attributes are set to today's date if they were
    # populated by the copy, if they were not populated leave them alone.
    unless page.active_from_date.value.nil? || page.active_from_date.value.strip.empty?
      page.active_from_date.fit right_now[:date_w_slashes]
    end
    unless page.active_to_date.value.nil? || page.active_to_date.value.strip.empty?
      page.active_to_date.fit right_now[:date_w_slashes]
    end

    #Now obtain all the data values from the page and use them to make our backing object
    document_attributes_hash = {
        :document_id                    => page.document_id,
        :initiator                      => page.initiator,
        :description                    => page.description_new
    }.merge(page.organization_review_data_new)

    @organization_review = make OrganizationReviewObject, document_attributes_hash
  end
end


And /^I create a primary delegation for a random Organization Review$/ do
  visit(MainPage).organization_review
  on OrganizationReviewLookupPage do |page|
    page.chart_code.fit   get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE_WITH_NAME)
    page.search
    page.wait_for_search_results
    page.create_delegation_random
  end
  on OrganizationReviewPage do |page|
    #Only data we are adding/modifying for this step, rest of the values come from create delegation action just performed.
    page.description.fit           'AFT OrganizationReview Create Delegation'
    page.delegation_type_code.fit   get_aft_parameter_value(ParameterConstants::DEFAULT_DELEGATION_TYPE_CODE)

    #Now obtain all the data values from the page and use them to make our backing object
    document_attributes_hash = {
        :document_id                    => page.document_id,
        :initiator                      => page.initiator,
        :description                    => page.description_new,
        :delegation_type_code           => page.delegation_type_code_new #attribute only on organization review edoc for this action, need to obtain manually
    }.merge(page.organization_review_data_new)

    @organization_review = make OrganizationReviewObject, document_attributes_hash
  end
end


And /^I submit the Organization Review document changing the Principal Name to a random KFS User$/ do
  # Getting a random person may cause a business rule to fail so we need to try a few times but
  # we need to limit the number of attempts to prevent a possible infinite loop.
  max_attempts = 3
  counter = 1

  # Note: Normally we would not output information as part of an AFT but this test has a higher probability
  #       of failing due to business rules being invoked with random data. Knowing what random data was
  #       attempted for each loop pass will clarify why the AFT failed.
  on OrganizationReviewPage do |page|
    new_principal_name = get_random_principal_name_for_role('KFS-SYS', 'User')
    page.principal_name.fit new_principal_name
    puts "Random principal name ##{counter} attempted =#{new_principal_name}="
    step 'I submit the Organization Review document'
    while (page.errors.include? 'This member is already associated with the role.') && (counter < max_attempts) do
      counter += 1
      # Obtain another person and attempt another submit action
      new_principal_name = get_random_principal_name_for_role('KFS-SYS', 'User')
      page.principal_name.fit new_principal_name
      puts "Random principal name ##{counter} attempted =#{new_principal_name}="
      step 'I submit the Organization Review document'
    end
  end
end
