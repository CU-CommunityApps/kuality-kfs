And /^I lookup an Object Code with that Object Sub Type$/ do
  object_code_having_object_sub_type = nil
  while true
    object_code_having_object_sub_type = get_random_object_code(@parameter_values.sample)
    break if object_code_having_object_sub_type != nil
  end
  @lookup_object_code = object_code_having_object_sub_type
end


When /^I Lookup the Object Code just entered$/ do
  visit(MainPage).object_code
  on ObjectCodeLookupPage do |page|
    page.chart_code.set  @object_code.new_chart_code
    page.object_code.fit @object_code.object_code
    page.search
    page.wait_for_search_results
    page.edit_item(@object_code.object_code)
  end
end

# This method presumes that the Object Code Lookup page is the one being shown in the browser when it is called.
And /^I lookup and return a random Object Code$/ do
  on ObjectCodeLookupPage do |obj_cd_page|
    obj_cd_page.chart_code.fit           get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
    obj_cd_page.object_code.fit          ''
    obj_cd_page.search
    obj_cd_page.wait_for_search_results
    obj_cd_page.return_random
  end
end
