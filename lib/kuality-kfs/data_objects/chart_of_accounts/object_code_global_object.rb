class ObjectCodeGlobalObject < KFSDataObject

  DOC_INFO = { label: 'Object Code Global', type_code: 'GOBJ', transactional?: false, action_wait_time: 30}

  attr_accessor :object_code,
                :object_code_name,
                :object_code_short_name,
                :reports_to_object_code,
                :object_type_code,
                :level_code,
                :cg_reporting_code,
                :object_sub_type_code,
                :financial_object_code_description,
                :historical_financial_object_code,
                :budget_aggregation_code,
                :mandatory_transfer,
                :federal_funded_code,
                :next_year_object_code

  def defaults
    # Ensure object code being used has not been used before
    begin
      default_object_code = random_alphanums(4)
    end until is_unique?(default_object_code)

    super.merge({
        object_code:              default_object_code, #Value must be one that does not currently exist; otherwise, user gets error 'This document cannot be Saved or Routed because a record with the same primary key already exists.'
        object_code_name:         "AFT created unique object code #{default_object_code}",
        object_code_short_name:   'AFTunique'
        #reports_to_object_code   attribute set by AFT parameter DEFAULTS_FOR_OBJECT_CODE_GLOBAL
        #object_type_code         attribute set by AFT parameter DEFAULTS_FOR_OBJECT_CODE_GLOBAL
        #level_code               attribute set by AFT parameter DEFAULTS_FOR_OBJECT_CODE_GLOBAL
        #cg_reporting_code        attribute set by AFT parameter DEFAULTS_FOR_OBJECT_CODE_GLOBAL
        #object_sub_type_code     attribute set by AFT parameter DEFAULTS_FOR_OBJECT_CODE_GLOBAL
        #budget_aggregation_code  attribute set by AFT parameter DEFAULTS_FOR_OBJECT_CODE_GLOBAL
        #mandatory_transfer:      attribute set by AFT parameter DEFAULTS_FOR_OBJECT_CODE_GLOBAL
        #federal_funded_code:     attribute set by AFT parameter DEFAULTS_FOR_OBJECT_CODE_GLOBAL
    }).merge(default_year_and_charts)
      .merge(get_aft_parameter_values_as_hash(ParameterConstants::DEFAULTS_FOR_OBJECT_CODE_GLOBAL))
  end


  def is_unique?(object_code_to_verify)
    # WebService will generate a RuntimeError when the object code value being looked up is not found.
    # That condition means the object code value does not currently exist and would be unique if it were to be added to the database.
    unique = false  #presuming object code value already exists in the database
    begin
      get_kuali_business_object('KFS-COA', 'ObjectCode', "universityFiscalYear=#{get_aft_parameter_value(ParameterConstants::CURRENT_FISCAL_YEAR)}&chartOfAccountsCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}&financialObjectCode=#{object_code_to_verify}&active=B")
    rescue RuntimeError
      unique = true  #did not find the object code, so it would be unique
    end
    unique
  end

  def build
    visit(MainPage).object_code_global
    on ObjectCodeGlobalPage do |page|
      page.description.focus
      page.alert.ok if page.alert.exists? # Because, y'know, sometimes it doesn't actually come up...

      fill_out page, *((self.class.superclass.attributes -
                        self.class.superclass.read_only_attributes -
                        self.class.notes_and_attachments_tab_mixin_attributes) +
                        self.class.attributes -
                        self.class.read_only_attributes -
                        self.class.year_and_charts_mixin_attributes) # We don't have any special attribute sections, so we should be able to throw them all in.
    end
  end

  # Class Methods:
  class << self
    # Attributes that are required for a successful save/submit.
    # @return [Array] List of Symbols for attributes that are required
    def required_attributes
      superclass.required_attributes | [ :object_code, :object_code_name, :object_code_short_name,
                                         :reports_to_object_code, :object_type_code, :level_code,
                                         :cg_reporting_code, :object_sub_type_code, :budget_aggregation_code,
                                         :mandatory_transfer, :federal_funded_code ]
    end
  end #class<<self

  include YearAndChartsLinesMixin

end #class
