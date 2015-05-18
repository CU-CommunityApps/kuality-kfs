class ParameterObject < KFSDataObject

  attr_accessor :namespace_code, :component, :application_id,
                :parameter_name, :parameter_value, :parameter_description,
                :parameter_type_code, :parameter_constraint_code_allowed, :parameter_constraint_code_denied,

                #Label 'component' is used interchangeably for both data attribute 'component' and 'component_name'.
                #Lookup requires component_name and is currently only used for updating and restoring parameter
                #values needed for a specific AFT; therefore, this attribute is being maintained in those steps
                #This may need to be revisited in the future.
                :component_name,

                #during a test a parameter attributes may need to to be changed, these attributes are used to hold the
                #original values for restoration at the end of the test
                :original_parameter_value, :original_parameter_description


  def defaults
    super.merge({
                  namespace_code:                     '',
                  component:                          '',
                  component_name:                     '',
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
          @namespace_code                    = get_option_value_from_namespace_code(page.new_namespace_code)
          @component                         = page.new_component
          @application_id                    = page.new_application_id
          @parameter_name                    = page.new_parameter_name
          @parameter_value                   = page.new_parameter_value
          @parameter_description             = page.new_parameter_description
          @parameter_type_code               = page.new_parameter_type_code
          @parameter_constraint_code_allowed = page.new_parameter_constraint_code == 'Allowed' ? :set : :clear
          @parameter_constraint_code_denied  = page.new_parameter_constraint_code == 'Denied' ? :set : :clear

        when :old
          @namespace_code                    = get_option_value_from_namespace_code(page.old_namespace_code)
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


  def update_value_remembering_original(value)
    @original_parameter_value = @parameter_value
    @parameter_value = value.to_s.gsub(',', ';')
  end


  def update_description_remembering_original(description)
    description.nil? ? 'Temporary change for automated functional tests.' : @original_parameter_description = @parameter_description
    @parameter_description = description
  end


  def get_option_value_from_namespace_code(namespace_code)
    option_value = ''
    if namespace_code.nil? or namespace_code.eql?('')
      option_value = ''
    else
      options = namespace_code.split(" ")
      option_value = options[0].strip
    end
    option_value
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
