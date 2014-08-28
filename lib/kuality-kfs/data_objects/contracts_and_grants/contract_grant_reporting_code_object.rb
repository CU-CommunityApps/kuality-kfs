class ContractGrantReportingCodeObject < KFSDataObject

  attr_accessor  :chart_code, :code, :name, :active_indicator

  DOC_INFO = { label: 'Contract Grant Reporting Code', type_code: 'OCGR' }

  def defaults
    super.merge({  chart_code:   get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE),
                   code:         random_alphanums(4),
                   name:         random_alphanums(9, 'Default CG Reporting Code Name ')
               })
  end

  def initialize(browser, opts={})
    @browser = browser
    set_options(defaults.merge(opts))
  end

  def build
    visit(MaintenancePage).cg_reporting_code
    on(ContractGrantsReportingCodeLookupPage).create_new
    on ContractGrantReportingCodePage do |page|
      page.description.focus
      page.alert.ok if page.alert.exists? # Because, y'know, sometimes it doesn't actually come up...
      fill_out page, :description, :chart_code, :code, :name
    end
  end

end
