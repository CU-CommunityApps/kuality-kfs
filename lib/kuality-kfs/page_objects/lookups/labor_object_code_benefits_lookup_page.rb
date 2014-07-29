class LaborObjectCodeBenefitsLookupPage < Lookups

  element(:fiscal_year) { |b| b.frm.text_field(name: 'universityFiscalYear') }
  element(:chart_code) { |b| b.frm.select(name: 'chartOfAccountsCode') }
  element(:object_code) { |b| b.frm.text_field(name: 'financialObjectCode') }

  element(:active_indicator_yes) { |b| b.frm.radio(id: 'activeYes') }
  element(:active_indicator_no) { |b| b.frm.radio(id: 'activeNo') }
  element(:active_indicator_both) { |b| b.frm.radio(id: 'activeBoth') }

  element(:find_item_in_table) { |item_name, b| b.results_table.link(text: item_name) }

end