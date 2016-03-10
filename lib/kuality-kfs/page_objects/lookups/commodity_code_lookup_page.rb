class CommodityCodeLookupPage < Lookups

  active_radios

  element(:sensitive_data) { |b| b.frm.select(name: 'sensitiveDataCode') }

  value(:clear_sensitive_data_selection) { |b| b.sensitive_data.exists? ? b.sensitive_data.selected_options.first.text : nil }
  value(:sensitive_data_new) { |b| b.sensitive_data.exists? ? b.sensitive_data.selected_options.first.text : nil }

end