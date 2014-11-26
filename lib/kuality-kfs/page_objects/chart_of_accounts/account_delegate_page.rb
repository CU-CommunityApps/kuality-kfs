class AccountDelegatePage < KFSBasePage

  element(:chart_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.chartOfAccountsCode') }
  element(:number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountNumber') }
  element(:doc_type_name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.financialDocumentTypeCode') }
  element(:principal_name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountDelegate.principalName') }
  element(:approval_from_amount) { |b| b.frm.text_field(name: 'document.newMaintainableObject.finDocApprovalFromThisAmt') }
  element(:approval_to_amount) { |b| b.frm.text_field(name: 'document.newMaintainableObject.finDocApprovalToThisAmt') }
  element(:primary_route) { |b| b.frm.checkbox(name: 'document.newMaintainableObject.accountsDelegatePrmrtIndicator') }
  element(:active) { |b| b.frm.checkbox(name: 'document.newMaintainableObject.active') }
  element(:start_date) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountDelegateStartDate') }

  value(:chart_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.chartOfAccountsCode.div').text.strip }
  value(:number_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.accountNumber.div').text.strip }
  value(:doc_type_name_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.financialDocumentTypeCode.div').text.strip }
  value(:principal_name_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.accountDelegate.principalName.div').text.strip }
  value(:approval_from_amount_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.finDocApprovalFromThisAmt.div').text.strip }
  value(:approval_to_amount_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.finDocApprovalToThisAmt.div').text.strip }
  value(:primary_route_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.accountsDelegatePrmrtIndicator.div').text.strip }
  value(:active_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.active.div').text.strip }
  value(:start_date_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.accountDelegateStartDate.div').text.strip }

  value(:chart_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.chartOfAccountsCode.div').text.strip }
  value(:number_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountNumber.div').text.strip }
  value(:doc_type_name_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.financialDocumentTypeCode.div').text.strip }
  value(:principal_name_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountDelegate.principalName.div').text.strip }
  value(:approval_from_amount_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.finDocApprovalFromThisAmt.div').text.strip }
  value(:approval_to_amount_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.finDocApprovalToThisAmt.div').text.strip }
  value(:primary_route_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountsDelegatePrmrtIndicator.div').text.strip }
  value(:active_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.active.div').text.strip }
  value(:start_date_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.accountDelegateStartDate.div').text.strip }

  value(:chart_code_new) { |b| b.chart_code.exists? ? b.chart_code.value : b.chart_code_readonly }
  value(:number_new) { |b| b.number.exists? ? b.number.value : b.number_readonly }
  value(:doc_type_name_new) { |b| b.doc_type_name.exists? ? b.doc_type_name.value : b.doc_type_name_readonly }
  value(:principal_name_new) { |b| b.principal_name.exists? ? b.principal_name.value : b.principal_name_readonly }
  value(:approval_from_amount_new) { |b| b.approval_from_amount.exists? ? b.approval_from_amount.value : b.approval_from_amount_readonly }
  value(:approval_to_amount_new) { |b| b.approval_to_amount.exists? ? b.approval_to_amount.value : b.approval_to_amount_readonly }
  value(:primary_route_new) { |b| b.primary_route.exists? ? b.primary_route.value : b.primary_route_readonly }
  value(:active_new) { |b| b.active.exists? ? b.active.value : b.active_readonly }
  value(:start_date_new) { |b| b.start_date.exists? ? b.start_date.value : b.start_date_readonly }

end