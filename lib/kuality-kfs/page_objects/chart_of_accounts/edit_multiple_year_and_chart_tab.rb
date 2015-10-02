class EditMultipleYearAndChartTab < KFSBasePage

  # Tab-related
  element(:edit_multiple_year_and_chart_tab) { |b| b.frm.div(id: 'tab-EditMultipleYearandChart-div') }
  value(:current_year_and_chart_count) { |b| b.icra_tab.spans(class: 'left', text: /Year and Chart [(]/m).length }
  action(:show_multiple_year_and_chart_button) { |b| b.frm.button(id: 'tab-EditMultipleYearandChart-imageToggle') }
  value(:multiple_year_and_chart_tab_shown?) { |b| b.show_multiple_year_and_chart_button.title.include?('close') }
  value(:multiple_year_and_chart_tab_hidden?) { |b| !b.multiple_year_and_chart_tab_shown? }
  action(:show_multiple_year_and_chart) { |b| b.show_multiple_year_and_chart_button.click }
  alias_method :hide_multiple_year_and_chart, :show_multiple_year_and_chart

  # Line interactions
  action(:add_year_and_chart_code) { |b| b.edit_multiple_year_and_chart_tab.button(name: 'methodToCall.addLine.objectCodeGlobalDetails.(!!org.kuali.kfs.coa.businessobject.ObjectCodeGlobalDetail!!).(:::;18;:::).anchor18').click }
  action(:delete_year_and_chart_code) { |i=0, b| b.edit_multiple_year_and_chart_tab.button(id: /methodToCall.deleteLine.objectCodeGlobalDetails.(!!.line#{i}/m).click }
  action(:add_multiple_chart_lines) { |b| b.edit_multiple_year_and_chart_tab.button(title: 'Multiple Value Search on Chart').click }

  # New Year and Chart entry
  element(:fiscal_year) { |b| b.edit_multiple_year_and_chart_tab.text_field(name: 'document.newMaintainableObject.add.objectCodeGlobalDetails.universityFiscalYear') }
  element(:chart_of_accounts_code) { |b| b.edit_multiple_year_and_chart_tab.select(id: 'document.newMaintainableObject.add.objectCodeGlobalDetails.chartOfAccountsCode') }

  # Year and Chart currently in the collection, data is not editable after being added to the array
  element(:fiscal_year_readonly) { |i=0, b| b.edit_multiple_year_and_chart_tab.span(id: "document.newMaintainableObject.objectCodeGlobalDetails[#{i}].universityFiscalYear.div").text.strip }
  element(:chart_of_accounts_code_readonly) { |i=0, b| b.edit_multiple_year_and_chart_tab.span(id: "document.newMaintainableObject.objectCodeGlobalDetails[#{i}].chartOfAccountsCode.div").text.strip }

end
