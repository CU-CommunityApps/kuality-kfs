And /^I create an Object Code Global document with default parameter data$/ do
  #Use the default setup when the object is created
  @object_code_global = create ObjectCodeGlobalObject
  #Add New Year and Chart values
  #no need to set fiscal year value as it defaults to the current fiscal year
  @object_code_global.year_and_charts.add chart_of_accounts_code: get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
end


And /^I create an Object Code Global document with a blank CG Reporting Code$/ do
  step 'I create an Object Code Global document with default parameter data'
  #ensure attribute CG Reporting Code is blank/empty
  @object_code_global.cg_reporting_code = ''
  on(ObjectCodeGlobalPage).cg_reporting_code.fit ''
end


And /^I create an Object Code Global document with a valid Reports to Object Code$/ do
  step 'I create an Object Code Global document with default parameter data'
  #ensure attribute Reports to Object Code is a valid value by getting one from the lookup
  on ObjectCodeGlobalPage do |page|
    page.reports_to_object_code_search
    # Chart CU must be used when looking up the reports to object code to prevent the error
    # "The Reports to Object Code (OBJECT_CODE_JUST_LOOKED_UP) does not exist for Chart (CU) and Fiscal Year (CURRENT_FISCAL_YEAR)."
    step "I lookup and return a random Object Code for chart #{get_aft_parameter_value(ParameterConstants::DEFAULT_CONSOLIDATED_FINANCIAL_REPORT_CHART_CODE)}"
    #make sure data object also has page value just selected
    @object_code_global.reports_to_object_code = page.reports_to_object_code_new
  end
end


And /^I start an Object Code Global document using an existing Object Code$/ do
  step 'I create an Object Code Global document with default parameter data'
  #Now ensure we are editing an existing object code
  on ObjectCodeGlobalPage do |page|
    page.object_code_search
    step "I lookup and return a random Object Code for chart #{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}"
    #make sure data object also has page value just selected
    @object_code_global.object_code = page.object_code_new
  end
end


And /^I enter the invalid CG Reporting Code of (.*) on the Object Code Global document$/ do |invalid_code|
  on(ObjectCodeGlobalPage).cg_reporting_code.fit invalid_code
  @object_code_global.cg_reporting_code = invalid_code
end


And /^I enter a valid CG Reporting Code on the Object Code Global document$/ do
  on ObjectCodeGlobalPage do |page|
    #Now get a valid CG Reporting Code value from the lookup on that page
    page.cg_reporting_code_search
    on ContractGrantsReportingCodeLookupPage do |cg_rptg_page|
      cg_rptg_page.chart_code.fit           get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
      cg_rptg_page.code.fit                 ''    #ensure Object Code value is blank prior to attempting lookup
      cg_rptg_page.search
      cg_rptg_page.wait_for_search_results
      cg_rptg_page.return_random
    end
    #make sure data object also has page value just selected
    @object_code_global.cg_reporting_code = page.cg_reporting_code_new
  end
end


And /^on the Object Code Global document, I update the Reports to Object Code$/ do
  #ensure attribute Reports to Object Code is a valid value by getting one from the lookup
  on ObjectCodeGlobalPage do |page|
    page.reports_to_object_code_search
    # Chart CU must be used when looking up the reports to object code to prevent the error
    # "The Reports to Object Code (OBJECT_CODE_JUST_LOOKED_UP) does not exist for Chart (CU) and Fiscal Year (CURRENT_FISCAL_YEAR)."
    step "I lookup and return a random Object Code for chart #{get_aft_parameter_value(ParameterConstants::DEFAULT_CONSOLIDATED_FINANCIAL_REPORT_CHART_CODE)}"
    #make sure data object also has page value just selected
    @object_code_global.reports_to_object_code = page.reports_to_object_code_new
  end
end

When /^I lookup the Object Code just entered with Object Code Global document$/ do
  step "I lookup the Object Code #{@object_code_global.object_code} for chart #{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)} just entered"
end

Then /^the Reports to Object Code just entered on the Object Code Global document should be displayed$/ do
  on(ObjectCodePage).reports_to_object_code.value.should == @object_code_global.reports_to_object_code
end
