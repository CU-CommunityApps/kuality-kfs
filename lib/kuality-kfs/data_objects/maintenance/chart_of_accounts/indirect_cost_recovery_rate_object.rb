class IndirectCostRecoveryRateObject < KFSDataObject

attr_accessor :fiscal_year, :rate_id, :active_indicator, :indirect_cost_recovery_rate_details


  DOC_INFO = { label: 'Indirect Cost Recovery Rate', type_code: 'ICRE' }

  def defaults
    super.merge({
                    fiscal_year:                            get_aft_parameter_value('CURRENT_FISCAL_YEAR'),
                    rate_id:                                random_alphanums(3),
                    active_indicator:                       :set,
                    indirect_cost_recovery_rate_details:    collection('IndirectCostRecoveryRateDetailLineObject')
               })
  end


  def build
    visit(MaintenancePage).indirect_cost_recovery_rate
    on(IndirectCostRecoveryRateLookupPage).create_new
    on IndirectCostRecoveryRatePage do |page|
      page.description.focus
      page.alert.ok if page.alert.exists? # Because, y'know, sometimes it doesn't actually come up...
      fill_out page, :description, :rate_id, :active_indicator
    end
  end

  def rate_id_new
    on IndirectCostRecoveryRatePage do |page|
      #ensure case of rate_id by obtaining it back from the text field
      @rate_id = page.rate_id.value.strip
    end
  end


  def create_wildcarded_icr_rate_for_random_institutional_object_codes(percent_to_use)
    #get random institutional allowance object code
    debit_object_code_info = get_kuali_business_object('KFS-COA','ObjectCode',"chartOfAccountsCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}&financialObjectLevelCode=IAEX&financialObjectTypeCode=ES&active=true")
    @debit_object_code = debit_object_code_info['financialObjectCode'][0]
    credit_object_code_info = get_kuali_business_object('KFS-COA','ObjectCode',"chartOfAccountsCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}&financialObjectLevelCode=IAIN&financialObjectTypeCode=IC&active=true")
    @credit_object_code = credit_object_code_info['financialObjectCode'][0]

    create_wildcarded_icr_rate_for_specified_institutional_object_codes percent_to_use, @debit_object_code, @credit_object_code
  end


  def create_wildcarded_icr_rate_for_specified_institutional_object_codes (percent_to_use, debit_object_code, credit_object_code)
    #need two icr rate details created, one for debit and one for credit
    icr_rate_debit_detail_opts = {
        chart_code:                   IndirectCostRecoveryRateDetailLineObject::DEBIT_WILDCARD,
        account_number:               IndirectCostRecoveryRateDetailLineObject::DEBIT_WILDCARD,
        sub_account_number:           IndirectCostRecoveryRateDetailLineObject::DEBIT_WILDCARD,
        object_code:                  debit_object_code,
        debit_credit_code:            'Debit',
        percent:                      percent_to_use,
        details_active_indicator:     :set
    }
    icr_rate_debit_detail = make IndirectCostRecoveryRateDetailLineObject
    icr_rate_debit_detail.add_new(icr_rate_debit_detail_opts)
    #determine index of detail just added

    #get data from page since "add" adjusts case and populates dependent data
    icr_rate_debit_detail_from_page = @indirect_cost_recovery_rate_details.pull_existing_detail(0, :new)
    self.indirect_cost_recovery_rate_details.push(icr_rate_debit_detail)

    icr_rate_credit_detail_opts =     {
        chart_code:                   IndirectCostRecoveryRateDetailLineObject::CREDIT_WILDCARD,
        account_number:               IndirectCostRecoveryRateDetailLineObject::CREDIT_WILDCARD,
        sub_account_number:           '',
        object_code:                  credit_object_code,
        debit_credit_code:            'Credit',
        percent:                      percent_to_use,
        details_active_indicator:     :set
    }
    icr_rate_credit_detail = make IndirectCostRecoveryRateDetailLineObject
    icr_rate_credit_detail.add_new(icr_rate_credit_detail_opts)
    #determine index of detail just added

    #get data from page since "add" adjusts case and populates dependent data
    #get data from page since "add" adjusts case and populates dependent data
    icr_rate_credit_detail_from_page = self.indirect_cost_recovery_rate_details.pull_existing_detail(1, :new)
    self.indirect_cost_recovery_rate_details.push(icr_rate_credit_detail)

    #ensure case of rate_id by obtaining it back from the page text field
    rate_id_new
  end

end