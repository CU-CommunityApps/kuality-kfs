class SubAccountObject < KFSDataObject

  include GlobalConfig

                #== Edit Sub-Account Code tab ==#
  attr_accessor :chart_code, :account_number, :sub_account_number, :name, :active_indicator, :sub_account_type_code,
                #== Edit Financial Reporting Code ==#
                :financial_reporting_chart_code, :financial_reporting_org_code, :financial_reporting_code,
                #== Edit CG Cost Sharing tab ==#
                :cost_sharing_account_number, :cost_sharing_chart_of_accounts_code, :cost_sharing_sub_account_number,
                #== Edit CG ICR tab ==#
                :icr_identifier, :icr_type_code, :icr_off_campus_indicator,
                #== ==#\
                :adhoc_approver_userid   #TODO This singleton data element is a collection on the page and needs to be coded as such.

#add if needed                :fin_reporting_chart_code, :fin_reporting_org_code, :fin_reporting_code,

  def defaults
    super.merge({
        chart_code:             get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE),
        account_number:         get_aft_parameter_value(ParameterConstants::DEFAULT_ACCOUNT_NUMBER),
        sub_account_number:     random_alphanums(5),
        name:                   random_alphanums(10),
        sub_account_type_code:  get_aft_parameter_value(ParameterConstants::DEFAULT_EXPENSE_SUB_ACCOUNT_TYPE_CODE)
    }).merge(default_icr_accounts)
      .merge(get_aft_parameter_values_as_hash(ParameterConstants::DEFAULTS_FOR_SUB_ACCOUNT))
  end


  def build
    visit(MainPage).sub_account
    on(SubAccountLookupPage).create
    on SubAccountPage do |page|
      page.expand_all
      page.description.focus
      page.alert.ok if page.alert.exists? # Because, y'know, sometimes it doesn't actually come up...

      fill_out page, :description, :chart_code, :account_number, :sub_account_number, :name,
               :cost_sharing_account_number, :cost_sharing_chart_of_accounts_code,
               :sub_account_type_code

      add_adhoc_approver(page) unless @adhoc_approver_userid.nil?
    end
  end


  # Note: You'll need to update the subcollections separately.
  def edit(opts={})
      on SubAccountPage do |page|
        edit_fields opts, page, :description, :name, :active_indicator, :sub_account_type_code,
                                :cost_sharing_chart_of_accounts_code, :cost_sharing_account_number,
                                :icr_identifier, :icr_type_code

      end
  end

  def add_adhoc_approver(page)
    page.expand_all
    page.ad_hoc_person.fit @adhoc_approver_userid
    page.ad_hoc_person_add
  end


  def absorb!(target={})
    super
    update_options(on(SubAccountPage).send("sub_account_data_#{target.to_s}"))
    update_line_objects_from_page!(target)
  end


  # Class Methods:
  class << self

    # Attributes that are required for a successful save/submit.
    # @return [Array] List of Symbols for attributes that are required
    def required_attributes
      superclass.required_attributes | [ :chart_code, :account_number, :name, :sub_account_number, :sub_account_type_code]
    end

  end #class<<self

  include IndirectCostRecoveryLinesMixin

end