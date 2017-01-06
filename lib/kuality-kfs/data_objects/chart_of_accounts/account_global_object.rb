class AccountGlobalObject < KFSDataObject

  DOC_INFO = { label: 'Account Global', type_code: 'GACC', transactional?: false, action_wait_time: 30}

  attr_accessor :fo_principal_name, :supervisor_principal_name,
                :organization_code, :sub_fund_group_code, :acct_expire_date,
                :postal_code, :city, :state, :address,
                :continuation_coa_code, :continuation_acct_number, :income_stream_financial_cost_code, :income_stream_account_number,
                :cfda_number,  :higher_ed_funct_code, :sufficient_funds_code,
                :trans_processing_sufficient_funds_code, :labor_benefit_rate_category_code,
                :new_chart_code, :new_number,
                # Extended Attributes
                :major_reporting_category_code

  def defaults

    super.merge({
        new_chart_code:                         get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE),
        new_number:                             get_random_account_number,
        supervisor_principal_name:              get_aft_parameter_value(ParameterConstants::DEFAULT_SUPERVISOR),
        manager_principal_name:                 get_aft_parameter_value(ParameterConstants::DEFAULT_MANAGER),
        organization_code:                      get_aft_parameter_value(ParameterConstants::DEFAULT_ORGANIZATION_CODE),
        sub_fund_group_code:                    '',
        acct_expire_date:                       '',
        postal_code:                            get_random_postal_code('*'),
        city:                                   generate_random_city,
        state:                                  get_random_state_code,
        address:                                generate_random_address,
        continuation_coa_code:                  '',
        continuation_acct_number:               '',
        income_stream_financial_cost_code:      get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE_WITH_NAME),
        income_stream_account_number:           get_aft_parameter_value(ParameterConstants::DEFAULT_INCOME_STREAM_ACCOUNT_NUMBER),
        cfda_number:                            '',
        higher_ed_funct_code:                   '',
        sufficient_funds_code:                  get_aft_parameter_value(ParameterConstants::DEFAULT_SUFFICIENT_FUNDS_CODE),
        trans_processing_sufficient_funds_code: '',
        labor_benefit_rate_category_code:       '',
    })
  end

  def build
    visit(MainPage).account_global
    on AccountGlobalPage do |page|
      page.description.focus
      page.alert.ok if page.alert.exists?
      fill_out page, :description, :fo_principal_name, :supervisor_principal_name,
               :organization_code, :sub_fund_group_code, :acct_expire_date,
               :postal_code, :city, :state, :address,
               :continuation_coa_code, :continuation_acct_number, :income_stream_financial_cost_code, :income_stream_account_number,
               :cfda_number,  :higher_ed_funct_code, :sufficient_funds_code,
               :trans_processing_sufficient_funds_code, :labor_benefit_rate_category_code,
               :new_chart_code, :new_number
      page.add_account_detail
    end
  end

  def add_multiple_accounting_lines
    unless @add_multiple_accounting_lines.nil?
      on(AccountGlobalPage).add_multiple_accounting_lines
      on AccountGlobalLookupPage do |page|
        page.account_number.fit @search_account_number
        page.search
        page.select_all_rows_from_this_page
        page.return_selected_results
      end
    end
  end

  def fill_out_extended_attributes
    on(AccountGlobalPage) { |p| fill_out p, :major_reporting_category_code }
  end

end
