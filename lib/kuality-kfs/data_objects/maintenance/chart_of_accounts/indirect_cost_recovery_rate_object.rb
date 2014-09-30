class IndirectCostRecoveryRateObject < KFSDataObject

  attr_accessor :rate_id, :chart_code, :account_number, :sub_account_number, :object_code, :debit_credit_code, :percent,
                :credit_object_code, :debit_object_code

  DOC_INFO = { label: 'Indirect Cost Recovery Rate', type_code: 'ICRE' }

  def defaults

    super.merge({
                    rate_id:              random_alphanums(3),
                    chart_code:           get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE),
               })
  end


  def build
    visit(MaintenancePage).indirect_cost_recovery_rate
    on(IndirectCostRecoveryRateLookupPage).create_new
    on IndirectCostRecoveryRatePage do |page|
      page.description.focus
      page.alert.ok if page.alert.exists? # Because, y'know, sometimes it doesn't actually come up...
      fill_out page, :description, :rate_id, :chart_code
    end
  end


  def create_wildcard_icr_for_random_institutional_object_codes(percent)
    #get random institutional allowance object code
    debit_object_code_info = get_kuali_business_object('KFS-COA','ObjectCode',"chartOfAccountsCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}&financialObjectLevelCode=IAEX&financialObjectTypeCode=ES&active=true")
    @debit_object_code = debit_object_code_info['financialObjectCode'][0]
    credit_object_code_info = get_kuali_business_object('KFS-COA','ObjectCode',"chartOfAccountsCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}&financialObjectLevelCode=IAIN&financialObjectTypeCode=IC&active=true")
    @credit_object_code = credit_object_code_info['financialObjectCode'][0]

    create_wildcard_indirect_cost_recovery_rate(percent, @debit_object_code, @credit_object_code)
  end


  def create_wildcard_icr_for_specified_institutional_object_codes (percent, indirect_cost_rate_debit_object_code, indirect_cost_rate_credit_object_code)
    create_wildcard_indirect_cost_recovery_rate(percent, indirect_cost_rate_debit_object_code, indirect_cost_rate_credit_object_code)
    @debit_object_code = indirect_cost_rate_debit_object_code
    @credit_object_code = indirect_cost_rate_credit_object_code
  end


  def create_wildcard_indirect_cost_recovery_rate (percent, debit_object_code, credit_object_code)
    indirect_cost_recovery_rate_debit_wildcard = '@'
    indirect_cost_recovery_rate_credit_wildcard = '#'

    on IndirectCostRecoveryRatePage do |page|
      #create debit
      page.chart_code.fit indirect_cost_recovery_rate_debit_wildcard
      page.account_number.fit indirect_cost_recovery_rate_debit_wildcard
      page.sub_account_number.fit indirect_cost_recovery_rate_debit_wildcard
      page.object_code.fit debit_object_code
      page.debit_credit_code.select 'Debit'
      page.percent.fit percent
      page.add_indirect_cost_recovery_rate
      #create credit
      page.chart_code.fit indirect_cost_recovery_rate_credit_wildcard
      page.account_number.fit indirect_cost_recovery_rate_credit_wildcard
      #sub_account_code purposely not set
      page.object_code.fit credit_object_code
      page.debit_credit_code.select 'Credit'
      page.percent.fit percent
      page.add_indirect_cost_recovery_rate
      #ensure case of rate_id by obtaining it from the text field
      @rate_id = page.rate_id.value.strip
    end
  end

end