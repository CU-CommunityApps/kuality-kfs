And /^I (update|restore) the (.*) Parameter for the (.*) component in the (.*) namespace with the values (.*) and (.*) description$/ do |action, parameter_name, component_name, namespace_code, parameter_values, parm_description|
  step "I lookup the #{parameter_name} Parameter for the #{component_name} component in the #{namespace_code} namespace"

  @parameter = make ParameterObject
  @parameter.absorb! :old
  #need to set component_name attribute used in the lookup
  @parameter.component_name = component_name

  options = {
        description:            (action.eql?('update')) ? 'Temporary NEW parameter for AFT' : "Restoring original parameter in AFT",
        parameter_description:  @parameter.update_description_remembering_original(parm_description),
        parameter_value:        @parameter.update_value_remembering_original(parameter_values)
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

# This step causes the global hash @test_input_data to come into existence.
# This is a Hash of the Parameter Values in the Parameter table for the specified Parameter Name.
Given /^I obtain (.*) data values required for the test from the Parameter table$/ do |parameter_name|
  @test_input_data = get_aft_parameter_values_as_hash(parameter_name)
end
