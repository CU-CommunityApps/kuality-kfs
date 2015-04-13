And /^I find a value for a parameter named (.*) for the (.*) document$/ do |param_name, document|
  @browser.goto "#{$base_rice_url}kr/maintenance.do?businessObjectClassName=org.kuali.rice.coreservice.impl.parameter.ParameterBo&name=#{param_name}&componentCode=#{document.gsub(' ', '')}&namespaceCode=KFS-FP&applicationId=KFS&methodToCall=edit"
  @parameter_values = on(ParameterPage).parameter_value.value.split(";")
end


And /^I (update|restore) the (.*) Parameter for the (.*) component in the (.*) namespace with the values (.*)$/ do |action, parameter_name, component, namespace_code, parameter_values|
  step "I lookup the #{parameter_name} Parameter for the #{component} component in the #{namespace_code} namespace"

  @parameter = make ParameterObject
  @parameter.absorb! :old

  options = {
        description:            'Temporary change for AFT value.',
        parameter_description:  'Temporary change for automated functional tests.',
        parameter_value:        @parameter.update_values_remembering_original(parameter_values)
  }

  @parameter.edit options
  on ParameterPage do |page|
    @parameter.document_id = page.document_id
  end
end


And /^I lookup the (.*) Parameter for the (.*) component in the (.*) namespace$/ do |parameter_name, component, namespace_code|
  visit(AdministrationPage).parameter
  on ParameterLookup do |lookup|
    lookup.namespace_code.select_value(/#{namespace_code}/m)
    lookup.component.fit      component
    lookup.parameter_name.fit parameter_name
    lookup.search
    lookup.edit_random # There can only be one!
  end
end


And /^I finalize the Parameter document$/ do
  # Note: this means you'll change users before the end of this step.
  step 'the Parameter document goes to ENROUTE'
  step 'I am logged in as a KFS Parameter Change Approver'
  step 'I view the Parameter document'
  step 'I approve the Parameter document'
  step 'the Parameter document goes to FINAL'
end


# This step causes the global hash @test_input_data to come into existence.
# This is a Hash of the Parameter Values in the Parameter table for the specified Parameter Name.
Given /^I obtain (.*) data values required for the test from the Parameter table$/ do |parameter_name|
  @test_input_data = get_aft_parameter_values_as_hash(parameter_name)
end


When /^I update an application Parameter to allow revenue object codes on a Pre-Encumbrance document$/ do
  system_parameter = get_aft_parameter_values_as_hash(ParameterConstants::DEFAULT_PREENCUMBRANCE_REVENUE_OBJECT_CODE_PARAMETER_AND_VALUE)
  step "I update the #{system_parameter[:parameter_name]} Parameter for the #{system_parameter[:component]} component in the #{system_parameter[:namespace_code]} namespace with the values #{system_parameter[:parameter_value]}"
end


And /^I restore the application parameter to its original value$/ do
  step "I update the #{@parameter.parameter_name} Parameter for the #{@parameter.component} component in the #{@parameter.namespace_code} namespace with the values #{@parameter.original_parameter_value}"
end