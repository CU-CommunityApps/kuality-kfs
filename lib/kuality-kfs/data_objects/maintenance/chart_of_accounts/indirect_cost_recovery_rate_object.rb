class IndirectCostRecoveryRateObject < KFSDataObject

  DOC_INFO = { label: 'Indirect Cost Recovery Rate', type_code: 'ICRE', transactional?: false, action_wait_time: 30 }

  attr_accessor :fiscal_year, :rate_id, :active_indicator, :indirect_cost_recovery_rate_details

  def defaults
    super.merge({
                    fiscal_year:                            get_aft_parameter_value(ParameterConstants::CURRENT_FISCAL_YEAR),
                    rate_id:                                generate_random_indirect_cost_recovery_rate_id,
                    active_indicator:                       :set,
                    indirect_cost_recovery_rate_details:    collection('IndirectCostRecoveryRateDetailLineObject')
               })
  end


  def build
    visit(MaintenancePage).indirect_cost_recovery_rate
    on(IndirectCostRecoveryRateLookupPage).create_new
    on IndirectCostRecoveryRatePage do |page|
      page.description.focus
      page.alert.ok if page.alert.exists?
      fill_out page, :description, :rate_id, :active_indicator
    end
  end


  def absorb!(target=:new)
    super
    update_options(pull_indirect_cost_recovery_rate_data(target))
    update_line_objects_from_page!(target)
  end


  # @return [Hash] The return values of attributes for the new Indirect Cost Recovery Rate
  def pull_indirect_cost_recovery_rate_data(target=:new)
    pulled_indirect_cost_recovery_rate = Hash.new
    on IndirectCostRecoveryRatePage do |page|
      page.expand_all
      case target
        when :new;      pulled_indirect_cost_recovery_rate = {
                            fiscal_year:        page.fiscal_year_new,
                            rate_id:            page.rate_id_new,
                            active_indicator:   page.active_indicator_new
                        }
        #TODO implement :old when needed
      end
    end
    pulled_indirect_cost_recovery_rate.merge(pull_indirect_cost_recovery_rate_extended_data(target))
  end


  def pull_indirect_cost_recovery_rate_extended_data(target=:new)
    Hash.new
  end


  def update_line_objects_from_page!(target=:new)
    @indirect_cost_recovery_rate_details.update_from_page! target
    super
  end

end
