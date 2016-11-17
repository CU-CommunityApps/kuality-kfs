class AccountDelegateObject < KFSDataObject

  DOC_INFO = { label: 'Account Delegate', type_code: 'ADEL', transactional?: false, action_wait_time: 30}

  attr_accessor :chart_code, :number, :doc_type_name, :principal_name,
                :approval_from_amount, :approval_to_amount, :primary_route, :active, :start_date

  def defaults
    super.merge({
        chart_code:           get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE),
        number:               random_alphanums(7),
        principal_name:       get_random_principal_name_for_role('KFS-SYS', 'User'),
    }).merge(get_aft_parameter_values_as_hash(ParameterConstants::DEFAULTS_FOR_ACCOUNT_DELEGATE))
  end

  def build
    visit(MainPage).account_delegate
    on(AccountDelegateLookupPage).create
    on AccountDelegatePage do |page|
      page.expand_all
      page.description.focus
      page.alert.ok if page.alert.exists?
      fill_out page, :description, :chart_code, :number, :doc_type_name, :principal_name, :start_date
    end
  end


  # Class Methods:
  class << self

    # Attributes that are required for a successful save/submit.
    # @return [Array] List of Symbols for attributes that are required
    def required_attributes
      superclass.required_attributes | [ :chart_code, :number, :doc_type_name, :principal_name, :start_date]
    end

  end

end
