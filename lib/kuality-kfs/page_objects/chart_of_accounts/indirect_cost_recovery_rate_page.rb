class IndirectCostRecoveryRatePage < KFSBasePage

  element(:rate_id) { |b| b.frm.text_field(name: 'document.newMaintainableObject.financialIcrSeriesIdentifier') }
  element(:chart_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.add.indirectCostRecoveryRateDetails.chartOfAccountsCode') }
  element(:account_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.add.indirectCostRecoveryRateDetails.accountNumber') }
  element(:sub_account_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.add.indirectCostRecoveryRateDetails.subAccountNumber') }
  element(:object_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.add.indirectCostRecoveryRateDetails.financialObjectCode') }
  element(:debit_credit_code) { |b| b.frm.select(name: 'document.newMaintainableObject.add.indirectCostRecoveryRateDetails.transactionDebitIndicator') }
  element(:percent) { |b| b.frm.text_field(name: 'document.newMaintainableObject.add.indirectCostRecoveryRateDetails.awardIndrCostRcvyRatePct') }

  action(:add_indirect_cost_recovery_rate) { |b| b.frm.button(name: 'methodToCall.addLine.indirectCostRecoveryRateDetails.(!!org.kuali.kfs.coa.businessobject.IndirectCostRecoveryRateDetail!!).(:::;5;:::).anchor5').click }

end