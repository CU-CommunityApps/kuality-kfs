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
                :next_year_object_code,
                # == Extended Attributes ==
                :suny_object_code

  def defaults
    # Ensure object code being used has not been used before otherwise, user gets error
    # 'This document cannot be Saved or Routed because a record with the same primary key already exists.'
    begin
      default_object_code = generate_random_object_code
    end until is_unique?(default_object_code)

    super.merge({
        object_code:              default_object_code, #Value must be one that does not currently exist;
        object_code_name:         generate_random_object_code_name,
        object_code_short_name:   'AFTunique'
    }).merge(default_year_and_charts)
      .merge(get_aft_parameter_values_as_hash(ParameterConstants::DEFAULTS_FOR_OBJECT_CODE_GLOBAL))
  end

  def fill_out_extended_attributes
    on(ObjectCodeGlobalPage) do |page|
      fill_out page, :suny_object_code
    end
  end

  def is_unique?(object_code_to_verify)
    # when object code exists it is not unique
    does_object_code_exist_for_current_fiscal_and_default_chart?(object_code_to_verify) ? false : true
  end

  def build
    visit(MainPage).object_code_global
    on ObjectCodeGlobalPage do |page|
      page.description.focus
      page.alert.ok if page.alert.exists?

      fill_out page, *((self.class.superclass.attributes -
                        self.class.superclass.read_only_attributes) +
                        self.class.attributes -
                        self.class.read_only_attributes -
                        self.class.year_and_charts_mixin_attributes)
    end
  end


  class << self
    # Attributes that are required for a successful save/submit.
    # @return [Array] List of Symbols for attributes that are required
    def required_attributes
      superclass.required_attributes | [ :object_code, :object_code_name, :object_code_short_name,
                                         :reports_to_object_code, :object_type_code, :level_code,
                                         :cg_reporting_code, :object_sub_type_code, :budget_aggregation_code,
                                         :mandatory_transfer, :federal_funded_code ]
    end
  end

  include YearAndChartsLinesMixin

end
