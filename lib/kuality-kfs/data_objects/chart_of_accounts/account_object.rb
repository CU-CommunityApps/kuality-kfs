class AccountObject < KFSDataObject

  DOC_INFO = { label: 'Account', type_code: 'ACCT', transactional?: false, action_wait_time: 30}

                # == Account Maintenance tab ==
  attr_accessor :chart_code, :number, :name, :organization_code, :campus_code,
                :effective_date, :account_expiration_date,
                :postal_code, :city, :state, :address, :closed,
                :type_code, :sub_fund_group_code, :higher_ed_funct_code, :restricted_status_code,
                # == Account Responsibility tab ==
                :fo_principal_name, :supervisor_principal_name, :manager_principal_name,
                :budget_record_level_code, :sufficient_funds_code,
                :income_stream_financial_cost_code, :income_stream_account_number,
                :continuation_account_number, :continuation_chart_code,
                # == Guidelines and Purpose tab ==
                :expense_guideline_text, :income_guideline_text, :purpose_text,
                # == Contracts and Grants tab ==
                :contract_control_chart_of_accounts_code, :contract_control_account_number,
                :account_icr_type_code, :indirect_cost_rate, :cfda_number, :cg_account_responsibility_id,
                :invoice_frequency_code, :invoice_type_code, :everify_indicator, :cost_share_for_project_number

  def defaults
    super.merge({
                  chart_code:                        get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE),
                  number:                            random_alphanums(7),
                  name:                              random_alphanums(10),
                  campus_code:                       get_aft_parameter_value(ParameterConstants::DEFAULT_CAMPUS_CODE),
                  postal_code:                       get_random_postal_code('*'),
                  city:                              get_generic_city,
                  state:                             get_random_state_code,
                  address:                           get_generic_address_1,
                  type_code:                         get_aft_parameter_value(ParameterConstants::DEFAULT_CAMPUS_TYPE_CODE),
                  fo_principal_name:                 get_aft_parameter_value(ParameterConstants::DEFAULT_FISCAL_OFFICER),
                  supervisor_principal_name:         get_aft_parameter_value(ParameterConstants::DEFAULT_SUPERVISOR),
                  manager_principal_name:            get_aft_parameter_value(ParameterConstants::DEFAULT_MANAGER),
                }).merge(default_icr_accounts)
                  .merge(get_aft_parameter_values_as_hash(ParameterConstants::DEFAULTS_FOR_ACCOUNT))
  end

  def build
    visit(MainPage).account
    on(AccountLookupPage).create
    on AccountPage do |page|
      page.expand_all
      page.type_code.fit @type_code # Gotta do this first or we get a modal
      page.description.focus
      page.alert.ok if page.alert.exists? # Because, y'know, sometimes it doesn't actually come up...
      fill_out page, *((self.class.superclass.attributes -
                        self.class.superclass.read_only_attributes -
                        self.class.notes_and_attachments_tab_mixin_attributes) +
                       self.class.attributes -
                       self.class.read_only_attributes -
                       self.class.icra_mixin_attributes) # We don't have any special attribute sections, so we should be able to throw them all in.
    end
  end


  def edit(opts={})
    # Verify what we are being asked to edit is one of our attributes
    opt_keys_to_update = opts.keys
    super_class_attribute_keys = self.class.superclass.attributes - self.class.superclass.read_only_attributes - self.class.notes_and_attachments_tab_mixin_attributes
    class_attribute_keys = self.class.attributes - self.class.read_only_attributes - self.class.icra_mixin_attributes
    missing_attribute_keys = opt_keys_to_update - super_class_attribute_keys - class_attribute_keys
    raise ArgumentError, "AccountObject was requested to edit attribute(s) #{missing_attribute_keys} which are undefined." if missing_attribute_keys.length != 0

    # Get this class's attributes keys/symbols that are specified in the opts parameter for editing.
    # Do not include the super class keys/symbols as those attributes will be edited via the call to the superclass
    # and will cause those same attributes to be updated a second time by this sub-class if included.
    keys_to_update = opt_keys_to_update & class_attribute_keys #intersection of two symbol arrays is what should be edited by this class

    super # Edit anything editable in KFSDataObject

    on(AccountPage) { |p| edit_fields opts, p, *keys_to_update }

    # This does mean that you can't update stuff from the ICRA Mixin via #edit, though.
    update_options(opts)
  end

  def absorb!(target={})
    super
    update_options(on(AccountPage).send("account_data_#{target.to_s}"))
    update_line_objects_from_page!(target)
  end


  # Class Methods:
  class << self
    # Attributes that are required for a successful save/submit.
    # @return [Array] List of Symbols for attributes that are required
    def required_attributes
      superclass.required_attributes | [ :chart_code, :number, :name, :organization_code,
                :campus_code, :effective_date, :account_expiration_date,
                :postal_code, :city, :state, :address,
                :type_code, :sub_fund_group_code, :higher_ed_funct_code, :restricted_status_code,
                :fo_principal_name, :supervisor_principal_name, :manager_principal_name,
                :budget_record_level_code, :sufficient_funds_code,
                :expense_guideline_text, :income_guideline_text, :purpose_text ]
    end

    # Attributes that don't copy over to a new document's fields during a copy.
    # @return [Array] List of Symbols for attributes that aren't copied to the new side of a copy
    def uncopied_attributes
      superclass.uncopied_attributes | [:chart_code, :number, :effective_date]
    end


    # Used in method absorb_webservice_item! or can be called standalone
    # @param [Hash][Array] data_item Single array element from a WebService call for the data object in question.
    # @return [Hash] A hash of the object's data attributes and the values provided in the data_item.
    def webservice_item_to_hash(data_item)
      coa_code_descr_hash = split_code_description_at_first_hyphen(data_item['chartOfAccounts.codeAndDescription'][0])
      org_code_descr_hash = split_code_description_at_first_hyphen(data_item['organization.codeAndDescription'][0])
      sub_fund_code_descr_hash = split_code_description_at_first_hyphen(data_item['subFundGroup.codeAndDescription'][0])
      fin_higher_ed_code_descr_hash = split_code_description_at_first_hyphen(data_item['financialHigherEdFunction.codeAndDescription'][0])

      data_hash = {
          description:                          'WebService provided data',
          chart_code:                           coa_code_descr_hash[:code],
          number:                               data_item['accountNumber'][0],
          name:                                 data_item['accountName'][0],
          organization_code:                    org_code_descr_hash[:code],
          campus_code:                          data_item['accountPhysicalCampusCode'][0],
          effective_date:                       data_item['accountEffectiveDate'][0],
          postal_code:                          data_item['accountZipCode'][0],
          city:                                 data_item['accountCityName'][0],
          state:                                data_item['accountStateCode'][0],
          address:                              data_item['accountStreetAddress'][0],
          type_code:                            data_item['accountTypeCode'][0],
          sub_fund_group_code:                  sub_fund_code_descr_hash[:code],
          higher_ed_funct_code:                 fin_higher_ed_code_descr_hash[:code],
          restricted_status_code:               data_item['accountRestrictedStatusCode'][0],
          fo_principal_name:                    data_item['accountFiscalOfficerUser.principalName'][0],
          supervisor_principal_name:            data_item['accountSupervisoryUser.principalName'][0],
          manager_principal_name:               data_item['accountManagerUser.principalName'][0],
          budget_record_level_code:             data_item['budgetRecordingLevelCode'][0],
          sufficient_funds_code:                data_item['accountSufficientFundsCode'][0],
          expense_guideline_text:               data_item['accountGuideline.accountExpenseGuidelineText'][0],
          income_guideline_txt:                 data_item['accountGuideline.accountIncomeGuidelineText'][0],
          purpose_text:                         data_item['accountGuideline.accountPurposeText'][0],
          labor_benefit_rate_cat_code:          data_item['laborBenefitRateCategoryCode'][0],
          account_expiration_date:              data_item['accountExpirationDate'][0],
          closed:                               data_item['closed'][0],
          income_stream_account_number:         data_item['incomeStreamAccountNumber'][0],
          income_stream_financial_cost_code:    data_item['incomeStreamFinancialCoaCode'][0]
      }.merge!(extended_webservice_item_to_hash(data_item))
    end

    # Override this method if you have site-specific extended attributes.
    def extended_webservice_item_to_hash(data_item)
      Hash.new
    end

  end #class<<self

  include IndirectCostRecoveryLinesMixin

end