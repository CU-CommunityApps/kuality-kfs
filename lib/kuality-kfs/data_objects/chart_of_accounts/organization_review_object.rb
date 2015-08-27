class OrganizationReviewObject < KFSDataObject

  DOC_INFO = { label: 'Organization Review', type_code: 'OR', transactional?: false, action_wait_time: 30}

  attr_accessor :chart_code, :organization_code, :doc_type, :review_types,
                :from_amount, :to_amount, :accounting_line_override_code, :principal_name,
                :namespace, :role_name, :group_namespace, :group_name, :action_type_code,
                :priority_number, :action_policy_code, :force_action, :active_from_date, :active_to_date

  def defaults
    super.merge({
        chart_code:             get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE_WITH_NAME),
        organization_code:      get_aft_parameter_value(ParameterConstants::DEFAULT_ORGANIZATION_CODE),
        #doc_type:              #set by DEFAULTS_FOR_ORGANIZATION_REVIEW, doc_type chosen selects/restricts attribute review_types value
        #review_types:          #review_type value directly depends on and is set/restricted when doc_type selected
        principal_name:         get_random_principal_name_for_role('KFS-SYS', 'User'),  #must be a valid value in the system
        #action_type_code:      #set by DEFAULTS_FOR_ORGANIZATION_REVIEW_ROLE
        #action_policy_code:    #has a default value set on the page, keep that value
    }).merge(get_aft_parameter_values_as_hash(ParameterConstants::DEFAULTS_FOR_ORGANIZATION_REVIEW))
  end

  def build
    visit(MainPage).organization_review
    on(OrganizationReviewLookupPage).create
    on OrganizationReviewPage do |page|
      page.expand_all
      page.description.focus
      page.alert.ok if page.alert.exists? # Because, y'know, sometimes it doesn't actually come up...
      fill_out page, :description, :chart_code, :organization_code, :principal_name, :action_type_code

      # Attribute :doc_type is read only on the page and must be populated through a lookup
      page.document_type_search
      on DocumentTypeLookupPage do |search|
        search.name.fit @doc_type
        search.search
        search.wait_for_search_results
        search.return_random
      end #doc_type lookup
    end
  end

  # Class Methods:
  class << self
    # Attributes that are required for a successful save/submit.
    # @return [Array] List of Symbols for attributes that are required
    def required_attributes
      superclass.required_attributes | [ :chart_code, :organization_code, :doc_type, :review_types,
                                         :action_type_code, :action_policy_code ]
    end
  end #class << self

end
