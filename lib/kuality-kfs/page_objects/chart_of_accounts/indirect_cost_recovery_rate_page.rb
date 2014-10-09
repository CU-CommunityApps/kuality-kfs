class IndirectCostRecoveryRatePage < KFSBasePage

  element(:fiscal_year) { |b| b.frm.text_field(name: 'document.newMaintainableObject.universityFiscalYear') }
  element(:rate_id) { |b| b.frm.text_field(name: 'document.newMaintainableObject.financialIcrSeriesIdentifier') }
  element(:active_indicator) { |b| b.frm.checkbox(name: 'document.newMaintainableObject.active') }


  # contains a single Indirect Cost Recovery Rate Detail Object that is going to be added on the page
  element(:icr_rate_detail_tab) { |b| b.frm.div(id: 'tab-EditIndirectCostRecoveryRates-div') }
  value(:current_icr_rate_detail_count) { |b| b.icr_rate_detail_tab.spans(class: 'left', text: /ICR Rate Detail [(]/m).length }

  element(:line_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.add.indirectCostRecoveryRateDetails.awardIndrCostRcvyEntryNbr.div') }  #has label ICR Entry Number
  element(:chart_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.add.indirectCostRecoveryRateDetails.chartOfAccountsCode') }
  element(:account_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.add.indirectCostRecoveryRateDetails.accountNumber') }
  element(:sub_account_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.add.indirectCostRecoveryRateDetails.subAccountNumber') }
  element(:object_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.add.indirectCostRecoveryRateDetails.financialObjectCode') }
  element(:sub_object_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.add.indirectCostRecoveryRateDetails.financialSubObjectCode') }
  element(:debit_credit_code) { |b| b.frm.select(name: 'document.newMaintainableObject.add.indirectCostRecoveryRateDetails.transactionDebitIndicator') }
  element(:percent) { |b| b.frm.text_field(name: 'document.newMaintainableObject.add.indirectCostRecoveryRateDetails.awardIndrCostRcvyRatePct') }
  element(:details_active_indicator) { |b| b.frm.checkbox(name: 'document.newMaintainableObject.add.indirectCostRecoveryRateDetails.active') }
  action(:add_icr_rate_detail) { |b| b.frm.button(name: 'methodToCall.addLine.indirectCostRecoveryRateDetails.(!!org.kuali.kfs.coa.businessobject.IndirectCostRecoveryRateDetail!!).(:::;5;:::).anchor5').click }


  # single Indirect Cost Recovery Rate Detail Object that is on the page and cannot be changed.
  element(:line_number_readonly) { |i=0, b| b.icr_rate_detail_tab.span(id: "document.newMaintainableObject.indirectCostRecoveryRateDetails[#{i}].awardIndrCostRcvyEntryNbr.div").value.strip } #has label ICR Entry Number
  element(:chart_code_readonly) { |i=0, b| b.icr_rate_detail_tab.span(id: "document.newMaintainableObject.indirectCostRecoveryRateDetails[#{i}].chartOfAccountsCode.div").value.strip  }
  element(:account_number_readonly) { |i=0, b| b.icr_rate_detail_tab.span(id: "document.newMaintainableObject.indirectCostRecoveryRateDetails[#{i}].accountNumber.div").value.strip  }
  element(:sub_account_number_readonly) { |i=0, b| b.icr_rate_detail_tab.span(id: "document.newMaintainableObject.indirectCostRecoveryRateDetails[#{i}].subAccountNumber.div").value.strip  }
  element(:object_code_readonly) { |i=0, b| b.icr_rate_detail_tab.span(id: "document.newMaintainableObject.indirectCostRecoveryRateDetails[#{i}].financialObjectCode.div").value.strip  }
  element(:sub_object_code_readonly) { |i=0, b| b.icr_rate_detail_tab.span(id: "document.newMaintainableObject.indirectCostRecoveryRateDetails[#{i}].financialSubObjectCode.div").value.strip  }
  element(:debit_credit_code_readonly) { |i=0, b| b.icr_rate_detail_tab.span(id: "document.newMaintainableObject.indirectCostRecoveryRateDetails[#{i}].transactionDebitIndicator.div").value.strip  }
  element(:percent_readonly) { |i=0, b| b.icr_rate_detail_tab.span(id: "document.newMaintainableObject.indirectCostRecoveryRateDetails[#{i}].awardIndrCostRcvyRatePct.div").value.strip  }
  element(:details_active_indicator_readonly) { |i=0, b| b.icr_rate_detail_tab.span.checkbox(id: "document.newMaintainableObject.indirectCostRecoveryRateDetails[#{i}].active") }

end