When /^I lookup the Object Code (.*) for chart (.*) just entered$/ do |object_code, chart_code|
  visit(MainPage).object_code
  on ObjectCodeLookupPage do |page|
    page.chart_code.fit  chart_code
    page.object_code.fit object_code
    page.search
    page.wait_for_search_results
    page.edit_item(object_code)
  end
end

# This method presumes that the Object Code Lookup page is the one being shown in the browser when it is called.
And /^I lookup and return a random Object Code for chart (.*)$/ do |chart_to_use|
  on ObjectCodeLookupPage do |obj_cd_page|
    obj_cd_page.chart_code.fit           chart_to_use
    obj_cd_page.object_code.fit          ''
    obj_cd_page.search
    obj_cd_page.wait_for_search_results
    obj_cd_page.return_random
  end
end
