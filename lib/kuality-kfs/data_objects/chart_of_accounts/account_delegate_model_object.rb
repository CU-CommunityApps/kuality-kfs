class AccountDelegateModelObject < KFSDataObject

  attr_accessor :chart_of_accounts_code, :organization_code, :account_delegate_model_name, :active_indicator, :document_type_name,
                :account_delegate_primary_route, :account_delegate_start_date, :approval_from_this_account,
                :approval_to_this_account, :account_delegate_principal_name, :active

  def defaults
    super.merge({
        description:                          random_alphanums(40, 'AFT'),
        chart_of_accounts_code:               get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE),
        account_delegate_model_name:          random_alphanums(40, 'AFT'),
        active_indicator:                     :set,
        active:                               :set
      }).merge(get_aft_parameter_values_as_hash(ParameterConstants::DEFAULTS_FOR_ACCOUNT_DELEGATE_MODEL))
  end

  def build
    visit(MainPage).account_delegate_model
    on(AccountDelegateModelLookupPage).create
    on AccountDelegateModelPage do |page|
      page.expand_all
      page.description.focus
      page.alert.ok if page.alert.exists? # Because, y'know, sometimes it doesn't actually come up...
      fill_out page, :description, :chart_of_accounts_code, :organization_code, :account_delegate_model_name, :active_indicator, :document_type_name,
                     :account_delegate_primary_route, :account_delegate_start_date, :approval_from_this_account,
                     :approval_to_this_account, :account_delegate_principal_name, :active
    end
  end

  # Class Methods:
  class << self

    # Attributes that are required for a successful save/submit.
    # @return [Array] List of Symbols for attributes that are required
    def required_attributes
      superclass.required_attributes | [ :chart_of_accounts_code, :organization_code, :account_delegate_model_name,
                                         :document_type_name, :account_delegate_start_date, :account_delegate_principal_name,
                                         :active_indicator, :active ]
    end

  end #class<<self

end
