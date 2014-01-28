class AdvanceDepositPage < FinancialProcessingPage

  document_overview
  financial_document_detail
  accounting_lines

  #need to make
  accounting_lines_for_capitalization
  modify_capital_assets

  general_ledger_pending_entries
  notes_and_attachments
  ad_hoc_recipients

#Advance Deposits
    value(:bank_code) { |b| b.frm.table(summary: 'Advance Deposits').td(class: 'infoline').text }
    element(:adv_deposit_date) { |b| b.frm.text_field(name: 'newAdvanceDeposit.financialDocumentAdvanceDepositDate') }
    element(:adv_deposit_reference_number) { |b| b.frm.text_field(name: 'newAdvanceDeposit.financialDocumentAdvanceDepositReferenceNumber') }
    element(:adv_deposit_description) { |b| b.frm.text_field(name: 'newAdvanceDeposit.financialDocumentAdvanceDepositDescription') }
    element(:adv_deposit_amount) { |b| b.frm.text_field(name: 'newAdvanceDeposit.financialDocumentAdvanceDepositAmount') }
    action(:add_an_advance_deposit) { |b| b.frm.button(title: 'Add an Advance Deposit').click }



#Accounting Lines for Capitalization
  #element(:accounting_lines_for_capitalization_select) { |line, p| p.frm.checkbox(id: 'document.capitalAccountingLines[#{line}.selectLine') }
  #action(:modify_asset) { |b| b.frm.button(name: 'methodToCall.modifyAsset').click }
  #action(:redistribute_capital_asset_amount) { |b| b.frm.button(name: 'methodToCall.redistributeModifyCapitalAssetAmount').click }
#Modify Capital Assets


end

