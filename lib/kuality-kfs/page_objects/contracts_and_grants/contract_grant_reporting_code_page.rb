class ContractGrantReportingCodePage < KFSBasePage

  element(:chart_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.chartOfAccountsCode') }
  element(:code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.code') }
  element(:name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.name') }

end