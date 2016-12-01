When /^I lookup a Rate ID using an alpha\-numeric value in the Indirect Cost Recovery Rate table$/ do
  visit(MaintenancePage).indirect_cost_recovery_rate

  on IndirectCostRecoveryRateLookupPage do |page|
   page.rate_id.set get_aft_parameter_value(ParameterConstants::DEFAULT_INDIRECT_COST_RECOVERY_RATE_ID)
   page.search
  end
end
