class ParameterObject < KFSDataObject

  attr_accessor :namespace_code, :component, :application_id,
                :parameter_name, :parameter_value, :parameter_description,
                :parameter_type_code, :parameter_constraint_code_allowed, :parameter_constraint_code_denied,

                #during a test a parameter value may need to to be changed, this attribute is used to hold the
                #original value for restoration at the end of the test
                :original_parameter_value


  def defaults
    super.merge({
                  namespace_code:                     '',
                  component:                          '',
                  application_id:                     '',
                  parameter_name:                     '',
                  parameter_description:              '',
                  parameter_type_code:                '',
                  parameter_constraint_code_allowed:  :clear,
                  parameter_constraint_code_denied:   :clear
    })
  end


  def edit(opts={})
    on ParameterPage do |page|
      edit_fields opts, page, :description, :parameter_value, :parameter_description, :parameter_type_code,
                              :parameter_constraint_code_allowed, :parameter_constraint_code_denied
    end
    sync_parameter_constraint_code
  end
  alias_method :update, :edit


  def build
    visit(AdministrationPage).parameter
    sync_parameter_constraint_code
    on ParameterPage do |page|
      fill_out page, :description, :namespace_code, :component, :application_id,
                     :parameter_name, :parameter_value, :parameter_description,
                     :parameter_type_code, :parameter_constraint_code_allowed, :parameter_constraint_code_denied
    end
  end


  def absorb!(target=:new)
    super
    on(ParameterPage) do |page|
      page.expand_all
      case target
        when :new
          @namespace_code                    = page.new_namespace_code
          @component                         = page.new_component
          @application_id                    = page.new_application_id
          @parameter_name                    = page.new_parameter_name
          @parameter_value                   = page.new_parameter_value
          @parameter_description             = page.new_parameter_description
          @parameter_type_code               = page.new_parameter_type_code
          @parameter_constraint_code_allowed = page.new_parameter_constraint_code == 'Allowed' ? :set : :clear
          @parameter_constraint_code_denied  = page.new_parameter_constraint_code == 'Denied' ? :set : :clear

        when :old
          @namespace_code                    = page.old_namespace_code
          @component                         = page.old_component
          @application_id                    = page.old_application_id
          @parameter_name                    = page.old_parameter_name
          @parameter_value                   = page.old_parameter_value
          @parameter_description             = page.old_parameter_description
          @parameter_type_code               = page.old_parameter_type_code
          @parameter_constraint_code_allowed = page.old_parameter_constraint_code == 'Allowed' ? :set : :clear
          @parameter_constraint_code_denied  = page.old_parameter_constraint_code == 'Denied' ? :set : :clear
      end
    end
  end


  # We want the parameter constraint codes to either be :set or nil but only one can
  # be :set at a time since this is a radio. This should update the other when one is set.
  def sync_parameter_constraint_code
    if @parameter_constraint_code_allowed == :set
      @parameter_constraint_code_denied = :clear
    elsif @parameter_constraint_code_denied == :set
      @parameter_constraint_code_allowed = :clear
    end
  end


  def update_values_remembering_original(value)
    @original_parameter_value = @parameter_value
    @parameter_value = value.to_s.gsub(',', ';')
  end


  # Class Methods:
  class << self

    # Attributes that are required for a successful save/submit.
    # @return [Array] List of Symbols for attributes that are required
    def required_attributes
      superclass.required_attributes | [ :namespace_code, :component, :application_id, :parameter_name,
                                         :parameter_description, :parameter_type_code,
                                         :parameter_constraint_code_allowed, :parameter_constraint_code_denied]
    end

  end #class<<self

end
