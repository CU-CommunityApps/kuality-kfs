class AssetManualPaymentPage < FinancialProcessingPage

  # Asset Allocation tab
  element(:asset_allocation) { |b| b.frm.select(name: 'allocationCode') }
  action(:select_asset_allocation) { |b| b.frm.button(name: 'methodToCall.selectAllocationType').click }

  # Assets tab
  element(:asset_number) { |b| b.frm.text_field(name: 'capitalAssetNumber') }
  action(:search_asset_number) { |b| b.frm.div(id: 'assets').button(name: /assetPaymentAssetDetail/).click }
  action(:add_asset_number) { |b| b.frm.div(id: 'assets').button(name: 'methodToCall.insertAssetPaymentAssetDetail').click }
  # data shown and button action for each asset added in the psudo-grid
  value(:capital_asset_number_value) { |l=0, b| b.frm.div(id: 'tab-Assets-div').table(class: 'datatable').input(type: 'hidden', name: "document.assetPaymentAssetDetail[#{l}].capitalAssetNumber").value }
  action(:allocate_amount) { |l=0, b| b.frm.div(id: 'assets').text_field(name: "document.assetPaymentAssetDetail[#{l}].allocatedUserValue") }
  value(:allocate_amount_value) { |l=0, b| b.frm.div(id: 'assets').text_field(name: "document.assetPaymentAssetDetail[#{l}].allocatedUserValue").value }
  action(:asset_number_update_view) { |l=0, b| b.frm.div(title: 'Update Allocations').button(name: "methodToCall.updateAssetPaymentAssetDetail.line#{l}").click }
  action(:asset_number_delete) { |l=0, b| b.frm.div(title: 'Delete asset').button(name: "methodToCall.deleteAssetPaymentAssetDetail.line#{l}").click }
  action(:asset_lines_row_count) do |b|
    b.frm.div(id: 'tab-Assets-div')
    .table(class: 'datatable')
    .elements(id: /document.assetPaymentAssetDetail(.*?)/).length # Should show up fairly consistently
  end

  # Accounting Lines tab
  accounting_lines  #super-class attributes defined used here: chart, account_number, sub_account, object, sub_object, project, org_ref_id, amount
  # additional accounting line data elements that are not defined in super-class but defined on this application page
  element(:source_po_number) { |b| b.frm.text_field(name: 'newSourceLine.purchaseOrderNumber') }
  element(:source_req_number) { |b| b.frm.text_field(name: 'newSourceLine.requisitionNumber') }
  element(:source_origin) { |b| b.frm.text_field(name: 'newSourceLine.expenditureFinancialSystemOriginationCode') }
  element(:source_doc_number) { |b| b.frm.text_field(name: 'newSourceLine.expenditureFinancialDocumentNumber') }
  element(:source_doc_type) { |b| b.frm.text_field(name: 'newSourceLine.expenditureFinancialDocumentTypeCode') }
  element(:source_posted_date) { |b| b.frm.text_field(name: 'newSourceLine.expenditureFinancialDocumentPostedDate') }
  value(:source_fiscal_year_value) { |b| b.frm.link(title: /^show inquiry for Accounting Period University Fiscal Year=/).text.strip }
  action(:add_acct_line) { |b| b.frm.button(alt: 'Add Source Accounting Line').click }
  action(:accounting_lines_row_count) do |b|
    b.frm.div(id: 'tab-AccountingLines-div')
    .table(class: 'datatable')
    .elements(name: /methodToCall.deleteSourceLine.line(.*?)/).length # Should show up fairly consistently
  end

  #FinancialProcessingPage items with these same names CANNOT be used as the widget name on FinancialProcessingPage is
  #singular and widget name on application AssetManualPaymentPage is defined to be plural
  action(:asset_manual_payment_update_chart_code) { |t='source', i=0, b| b.frm.select(name: "document.#{t}AccountingLines[#{i}].chartOfAccountsCode") }
  action(:asset_manual_payment_update_account_number) { |t='source', i=0, b| b.frm.text_field(name: "document.#{t}AccountingLines[#{i}].accountNumber") }
  action(:asset_manual_payment_update_sub_account_code) { |t='source', i=0, b| b.frm.text_field(name: "document.#{t}AccountingLines[#{i}].subAccountNumber") }
  action(:asset_manual_payment_update_object_code) { |t='source', i=0, b| b.frm.text_field(name: "document.#{t}AccountingLines[#{i}].financialObjectCode") }
  action(:asset_manual_payment_update_sub_object_code) { |t='source', i=0, b| b.frm.text_field(name: "document.#{t}AccountingLines[#{i}].financialSubObjectCode") }
  action(:asset_manual_payment_update_project_code) { |t='source', i=0, b| b.frm.text_field(name: "document.#{t}AccountingLines[#{i}].projectCode") }
  action(:asset_manual_payment_update_organization_reference_id) { |t='source', i=0, b| b.frm.text_field(name: "document.#{t}AccountingLines[#{i}].organizationReferenceId") }
  action(:asset_manual_payment_update_amount) { |t='source', i=0, b| b.frm.text_field(name: "document.#{t}AccountingLines[#{i}].amount") }
  #attributes only on the this page's accounting lines
  action(:asset_manual_payment_update_purchase_order_number) { |t='source', i=0, b| b.frm.text_field(name: "document.#{t}AccountingLines[#{i}].purchaseOrderNumber") }
  action(:asset_manual_payment_update_requisition_number) { |t='source', i=0, b| b.frm.text_field(name: "document.#{t}AccountingLines[#{i}].requisitionNumber") }
  action(:asset_manual_payment_update_origination_code) { |t='source', i=0, b| b.frm.text_field(name: "document.#{t}AccountingLines[#{i}].expenditureFinancialSystemOriginationCode") }
  action(:asset_manual_payment_update_document_number) { |t='source', i=0, b| b.frm.text_field(name: "document.#{t}AccountingLines[#{i}].expenditureFinancialDocumentNumber") }
  action(:asset_manual_payment_update_document_type_code) { |t='source', i=0, b| b.frm.text_field(name: "document.#{t}AccountingLines[#{i}].expenditureFinancialDocumentTypeCode") }
  action(:asset_manual_payment_update_posted_date) { |t='source', i=0, b| b.frm.text_field(name: "document.#{t}AccountingLines[#{i}].expenditureFinancialDocumentPostedDate") }

  action(:pull_existing_accounting_line_values) do |type='source', i=0, b|
    {   #common accounting line attributes
        chart_code:            (b.asset_manual_payment_update_chart_code(type, i).value                if b.asset_manual_payment_update_chart_code(type, i).visible?),
        account_number:        (b.asset_manual_payment_update_account_number(type, i).value            if b.asset_manual_payment_update_account_number(type, i).exists?),
        sub_account:           (b.asset_manual_payment_update_sub_account_code(type, i).value          if b.asset_manual_payment_update_sub_account_code(type, i).exists?),
        object:                (b.asset_manual_payment_update_object_code(type, i).value               if b.asset_manual_payment_update_object_code(type, i).exists?),
        sub_object:            (b.asset_manual_payment_update_sub_object_code(type, i).value           if b.asset_manual_payment_update_sub_object_code(type, i).exists?),
        project:               (b.asset_manual_payment_update_project_code(type, i).value              if b.asset_manual_payment_update_project_code(type, i).exists?),
        org_ref_id:            (b.asset_manual_payment_update_organization_reference_id(type, i).value if b.asset_manual_payment_update_organization_reference_id(type, i).exists?),
        amount:                (b.asset_manual_payment_update_amount(type, i).value                    if b.asset_manual_payment_update_amount(type, i).exists?),
        #extended accounting line attributes
        purchase_order_number: (b.asset_manual_payment_update_purchase_order_number(type, i).value     if b.asset_manual_payment_update_purchase_order_number(type, i).exists?),
        requisition_number:    (b.asset_manual_payment_update_requisition_number(type, i).value        if b.asset_manual_payment_update_requisition_number(type, i).exists?),
        origination_code:      (b.asset_manual_payment_update_origination_code(type, i).value          if b.asset_manual_payment_update_origination_code(type, i).exists?),
        document_number:       (b.asset_manual_payment_update_document_number(type, i).value           if b.asset_manual_payment_update_document_number(type, i).exists?),
        document_type_code:    (b.asset_manual_payment_update_document_type_code(type, i).value        if b.asset_manual_payment_update_document_type_code(type, i).exists?),
        posted_date:           (b.asset_manual_payment_update_posted_date(type, i).value               if b.asset_manual_payment_update_posted_date(type, i).exists?),
    }
  end
end