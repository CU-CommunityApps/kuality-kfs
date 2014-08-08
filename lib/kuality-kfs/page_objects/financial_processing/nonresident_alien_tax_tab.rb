class NonresidentAlienTaxTab < FinancialProcessingPage

  element(:nonresident_alien_tax_tab_toggle) { |b| b.frm.button(id: 'tab-NonresidentAlienTax-imageToggle') }
  action(:show_nonresident_alien_tax_tab) { |b| b.nonresident_alien_tax_tab_toggle.click }
  alias_method :hide_nonresident_alien_tax_tab, :show_nonresident_alien_tax_tab
  value(:nonresident_alien_tax_tab_shown?) { |b| b.nonresident_alien_tax_tab_toggle.title.include? 'close' }
  value(:nonresident_alien_tax_hidden?) { |b| b.nonresident_alien_tax_tab_toggle.title.include? 'open' }

  element(:income_class_code) { |b| b.frm.select(id: 'document.dvNonResidentAlienTax.incomeClassCode') }
  element(:federal_income_tax_pct) { |b| b.frm.text_field(id: 'document.dvNonResidentAlienTax.federalIncomeTaxPercent') }
  element(:state_income_tax_pct) { |b| b.frm.text_field(id: 'document.dvNonResidentAlienTax.stateIncomeTaxPercent') }
  element(:country_code) { |b| b.frm.select(id: 'document.dvNonResidentAlienTax.postalCountryCode') }

  action(:generate_line) { |b| b.frm.button(name: /methodToCall.generateNonResidentAlienTaxLines/m).click }

end