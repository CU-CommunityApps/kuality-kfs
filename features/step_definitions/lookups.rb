Then /^the Lookup should return results$/ do
  on(Lookups).results_table.rows.length.should > 0
end
