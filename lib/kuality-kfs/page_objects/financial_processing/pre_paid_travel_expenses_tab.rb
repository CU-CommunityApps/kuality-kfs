class PrePaidTravelExpensesTab < FinancialProcessingPage

  element(:pre_paid_travel_expense_tab_toggle) { |b| b.frm.button(id: 'tab-PrePaidTravelExpenses-imageToggle') }
  action(:show_pre_paid_travel_expense_tab) { |b| b.pre_paid_travel_expense_tab_toggle.click }
  alias_method :hide_pre_paid_travel_expense_tab, :show_pre_paid_travel_expense_tab
  value(:pre_paid_travel_expense_tab_shown?) { |b| b.pre_paid_travel_expense_tab_toggle.title.include? 'close' }
  value(:pre_paid_travel_expense_tab_hidden?) { |b| b.pre_paid_travel_expense_tab_toggle.title.include? 'open' }
  value(:current_expenses_count) { |b| b.frm.text_fields(id: /document\.dvPreConferenceDetail\.dvPreConferenceRegistrants\[\d+\]\.dvConferenceRegistrantName/).length }

  action(:labelled_fields) { |s, b| b.frm.th(text: /#{s}/m).parent.tds(class: 'datacell') }
  action(:labelled_field) { |s, c=0, b| b.labelled_fields(s)[c] }

  element(:location) { |b| b.frm.text_field(id: 'document.dvPreConferenceDetail.dvConferenceDestinationName') }
  element(:type) { |b| b.frm.select(id: 'document.dvPreConferenceDetail.disbVchrExpenseCode') }
  element(:start_date) { |b| b.frm.text_field(id: 'document.dvPreConferenceDetail.disbVchrConferenceStartDate') }
  element(:end_date) { |b| b.frm.text_field(id: 'document.dvPreConferenceDetail.disbVchrConferenceEndDate') }

  element(:name) { |b| b.frm.text_field(id: 'newPreConferenceRegistrantLine.dvConferenceRegistrantName') }
  element(:department_code) { |b| b.frm.text_field(id: 'newPreConferenceRegistrantLine.disbVchrPreConfDepartmentCd') }
  element(:req_instate) { |b| b.frm.text_field(id: 'newPreConferenceRegistrantLine.dvPreConferenceRequestNumber') }
  element(:amount) { |b| b.frm.text_field(id: 'newPreConferenceRegistrantLine.disbVchrExpenseAmount') }

  element(:update_name) { |i=0, b| b.frm.text_field(id: "document.dvPreConferenceDetail.dvPreConferenceRegistrants[#{i}].dvConferenceRegistrantName") }
  element(:update_department_code) { |i=0, b| b.frm.text_field(id: "document.dvPreConferenceDetail.dvPreConferenceRegistrants[#{i}].disbVchrPreConfDepartmentCd") }
  element(:update_req_instate) { |i=0, b| b.frm.text_field(id: "document.dvPreConferenceDetail.dvPreConferenceRegistrants[#{i}].dvPreConferenceRequestNumber") }
  element(:update_amount) { |i=0, b| b.frm.text_field(id: "document.dvPreConferenceDetail.dvPreConferenceRegistrants[#{i}].disbVchrExpenseAmount") }

  element(:add_pre_paid_expense_button) { |b| b.frm.button(name: 'methodToCall.addPreConfRegistrantLine') }
  action(:add_pre_paid_expense) { |b| b.add_pre_paid_expense_button.click }
  element(:delete_pre_paid_expense_button) { |i=0, b| b.frm.button(name: "methodToCall.deletePreConfRegistrantLine.line#{i}") }
  action(:delete_pre_paid_expense) { |b| b.delete_pre_paid_expense_button.click }

end
