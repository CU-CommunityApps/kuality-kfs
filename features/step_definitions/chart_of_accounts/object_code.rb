And /^I edit an Object Code document with object code (.*)$/ do |the_object_code|
  @object_code = make ObjectCodeObject, object_code: the_object_code

  visit(MainPage).object_code
  on ObjectCodeLookupPage do |page|
    page.object_code.fit      @object_code.object_code
    page.chart_code.fit       @object_code.new_chart_code
    page.search
    page.edit_item(the_object_code)
  end
end

And /^I edit an Object Code document$/ do
  @object_code = make ObjectCodeObject

  on(MainPage).object_code
  on ObjectCodeLookupPage do |page|
    page.search
    page.edit_random
  end
  on ObjectCodePage do |page|
    page.description.set random_alphanums(40, 'AFT')
    @object_code.document_id = page.document_id
  end
end

And /^I enter invalid CG Reporting Code of (.*)$/ do |the_reporting_code|
  on ObjectCodePage do |page|
    page.description.set @object_code.description
    page.cg_reporting_code.set the_reporting_code
  end
end

Then /^The object code should show an error that says "(.*?)"$/ do |error|
  on(ObjectCodePage).errors.should include error
end


And /^I update the Financial Object Code Description/ do
  on(ObjectCodePage).financial_object_code_description.set random_alphanums(60, 'AFT')
end


And /^I find a random Pre-Encumbrance Object Code$/ do
  random_attributes_hash = Hash.new
  random_attributes_hash = ObjectCodeObject.webservice_item_to_hash(get_random_object_code_object_for_pre_encumbrance)
  @object_code = make ObjectCodeObject, random_attributes_hash
  step "I add the object code to the stack"
end


And /^I add the object code to the stack$/ do
  @object_codes = @object_codes.nil? ? [@object_code] : @object_codes + [@object_code]
end

Then /^the Reports to Object Code just entered should be displayed$/ do
  on(ObjectCodePage).reports_to_object_code.value.should == @object_code.reports_to_object_code
end
