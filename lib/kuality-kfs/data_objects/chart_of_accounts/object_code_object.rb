class ObjectCodeObject < KFSDataObject

  attr_accessor :fiscal_year,
                :new_chart_code,
                :object_code,
                :object_code_name,
                :object_code_short_name,
                :reports_to_object_code,
                :object_type_code,
                :level_code,
                :object_sub_type_code,
                :financial_object_code_description,
                :cg_reporting_code,
                :historical_financial_object_code,
                :active_indicator,
                :budget_aggregation_code,
                :mandatory_transfer,
                :federal_funded_code,
                :next_year_object_code

  def defaults
    super.merge({
                      fiscal_year:                        get_aft_parameter_value('CURRENT_FISCAL_YEAR'),
                      new_chart_code:                     get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE_WITH_NAME),
                      object_code:                        random_alphanums(4), #if object code matches data user gets an error 'This document cannot be Saved or Routed because a record with the same primary key already exists.'
                      object_code_name:                   random_alphanums(10, 'AFT'),
                      object_code_short_name:             random_alphanums(5, 'AFT'),
                      financial_object_code_description:  random_alphanums(30, 'AFT'),
                      mandatory_transfer:                 '::random::',
                      federal_funded_code:                '::random::',
                }).merge(get_aft_parameter_values_as_hash(ParameterConstants::DEFAULTS_FOR_OBJECT_CODE))
  end


  def build
    visit(MainPage).object_code
    on(ObjectCodeLookupPage).create_new
    on ObjectCodePage do |page|
      page.description.focus
      page.alert.ok if page.alert.exists? # Because, y'know, sometimes it doesn't actually come up...
      fill_out page, *((self.class.superclass.attributes -
          self.class.superclass.read_only_attributes -
          self.class.notes_and_attachments_tab_mixin_attributes) +
          self.class.attributes -
          self.class.read_only_attributes) # We don't have any special attribute sections, so we should be able to throw them all in.
    end
  end


  # Class Methods:
  class << self
    # Attributes that are required for a successful save/submit.
    # @return [Array] List of Symbols for attributes that are required
    def required_attributes
      superclass.required_attributes | [ :fiscal_year, :new_chart_code, :object_code, :object_code_name,
                                         :object_code_short_name, :reports_to_object_code, :object_type_code,
                                         :level_code, :object_sub_type_code, :cg_reporting_code,
                                         :budget_aggregation_code, :mandatory_transfer ]
    end


    # Used in method absorb_webservice_item! or can be called standalone
    # @param [Hash][Array] data_item Single array element from a WebService call for the data object in question.
    # @return [Hash] A hash of the object's data attributes and the values provided in the data_item.
    def webservice_item_to_hash(data_item)
      data_hash = {
          description:                        'WebService provided data',
          fiscal_year:                        data_item['universityFiscalYear'][0],
          new_chart_code:                     data_item['chartOfAccountsCode'][0],
          object_code:                        data_item['financialObjectCode'][0],
          object_code_name:                   data_item['financialObjectCodeName'][0],
          object_code_short_name:             data_item['financialObjectCodeShortName'][0],
          reports_to_object_code:             data_item['reportsToFinancialObjectCode'][0],
          object_type_code:                   data_item['financialObjectTypeCode'][0],
          level_code:                         data_item['financialObjectLevelCode'][0],
          object_sub_type_code:               data_item['financialObjectSubTypeCode'][0],
          financial_object_code_description:  data_item['extension.financialObjectCodeDescr'][0],
          cg_reporting_code:                  data_item['extension.cgReportingCode'][0],
          historical_financial_object_code:   data_item['historicalFinancialObjectCode'][0],
          active_indicator:                   data_item['active'][0],
          budget_aggregation_code:            data_item['financialBudgetAggregationCd'][0],
          mandatory_transfer:                 data_item['finObjMandatoryTrnfrelimCd'][0],
          federal_funded_code:                data_item['financialFederalFundedCode'][0],
          next_year_object_code:              data_item['nextYearFinancialObjectCode'][0],
          suny_object_code:                   data_item['extension.sunyObjectCode'][0],
      }.merge!(extended_webservice_item_to_hash(data_item))
    end

    # Override this method if you have site-specific extended attributes.
    def extended_webservice_item_to_hash(data_item)
      Hash.new
    end

  end #class<<self

end #class