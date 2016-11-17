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
