class SubObjectCodeGlobalObject < KFSDataObject

  DOC_INFO = { label: 'Sub-Object Code Global', type_code: 'GSOB', transactional?: false, action_wait_time: 30}

  attr_accessor  :new_chart_code,
                 :organization_document_number,
                 :new_fiscal_year, :new_chart_code, :new_sub_object_code, :new_sub_object_code_name, :new_sub_object_code_short_name,
                 :noc_fiscal_year, :noc_chart_code, :noc_object_code,
                 :na_chart_code, :na_account_number

  def defaults
    super.merge({
        description:                    random_alphanums(40, 'AFT'),
        new_chart_code:                 get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE_WITH_NAME),
        organization_document_number:   get_aft_parameter_value(ParameterConstants::DEFAULT_ACCOUNT_NUMBER),
        new_fiscal_year:                get_aft_parameter_value(ParameterConstants::CURRENT_FISCAL_YEAR),
        new_sub_object_code_name:       random_alphanums(20, 'AFT'),
        new_sub_object_code_short_name: random_alphanums(5, 'ATF'),
        noc_fiscal_year:                get_aft_parameter_value(ParameterConstants::CURRENT_FISCAL_YEAR),
        noc_chart_code:                 get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE_WITH_NAME),
        na_chart_code:                  get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE_WITH_NAME),
        na_account_number:              get_aft_parameter_value(ParameterConstants::DEFAULT_ACCOUNT_NUMBER),
    }).merge(get_aft_parameter_values_as_hash(ParameterConstants::DEFAULTS_FOR_SUB_OBJECT_CODE_GLOBAL))
  end

  def build
    visit(MainPage).sub_object_code_global
    on SubObjectCodeGlobalPage do |page|
      page.expand_all
      page.description.focus
      page.alert.ok if page.alert.exists? # Because, y'know, sometimes it doesn't actually come up...
      fill_out page,  :description, :new_chart_code,
                      :organization_document_number,
                      :new_fiscal_year, :new_chart_code, :new_sub_object_code, :new_sub_object_code_name, :new_sub_object_code_short_name,
                      :noc_fiscal_year, :noc_chart_code, :noc_object_code,
                      :na_chart_code, :na_account_number
    end
  end

  def add_multiple_account_lines(search_code)
    on(SubObjectCodeGlobalPage).add_multiple_account_lines
    on AccountLookupPage do |page|
      page.organization_code.fit "#{search_code}"
      page.search
      page.select_all_from_this_page
      page.return_selected
    end
  end

end #class
