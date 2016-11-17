class AuxiliaryVoucherPage < FinancialProcessingPage

  financial_document_detail
  accounting_lines
  ad_hoc_recipients

  element(:accounting_period) { |b| b.frm.select(name: 'selectedAccountingPeriod') }
  element(:auxiliary_voucher_type_adjustment) { |b| b.frm.radio(title: '* Auxiliary Voucher Type - Adjustment') }
  element(:auxiliary_voucher_type_accrual) { |b| b.frm.radio(title: '* Auxiliary Voucher Type - Accrual') }
  element(:auxiliary_voucher_type_recode) { |b| b.frm.radio(title: '* Auxiliary Voucher Type - Recode') }

  action(:search_account_number) { |b| b.frm.button(title: 'Search Account Number').click }
  action(:search_sub_account_code) { |b| b.frm.button(title: 'Search Sub-Account Code').click }
  action(:search_object_code) { |b| b.frm.button(title: 'Search Object Code').click }
  action(:search_sub_object_code) { |b| b.frm.button(title: 'Search Sub-Object Code').click }
  action(:search_project_code) { |b| b.frm.button(title: 'Search Project Code').click }

end
