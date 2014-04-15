class ContractManagerAssignmentPage < KFSBasePage

      # element(:organization_document_number) { |b| b.frm.text_field(name: 'document.documentHeader.organizationDocumentNumber') }
      action(:contract_manager) { |l=0, b| b.frm.text_field(name: "document.contractManagerAssignmentDetail[#{l}].contractManagerCode") }
      #tr where the requisition number exists is where the cm to fill in should be one td up/left

      # the index-1 is needed because it was filling in the wrong/next row
      action(:set_contract_manager) { |req_number, cm_number='10', b| b.frm.table(summary: 'Assign A Contract Manager').rows.each_with_index {|row, index| b.contract_manager(index-1).set cm_number if row.a(text: req_number).exists? } }
      #NEEDS TO 'BREAK' loop after finding value,

end