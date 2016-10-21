class PreEncumbrancePage < FinancialProcessingPage

  financial_document_detail
  accounting_lines
  ad_hoc_recipients

  #pre_encumbrance_details
  element(:reversal_date) { |b| b.frm.text_field(name: 'document.reversalDate') }

  #accounting_lines_encumbrance_disencumbrance
  #ENCUMBRANCE
  alias_method :encumbrance_chart_code, :source_chart_code
  alias_method :encumbrance_account_number, :source_account_number
  alias_method :encumbrance_sub_account, :source_sub_account_code
  alias_method :encumbrance_object, :source_object_code
  alias_method :encumbrance_sub_object, :source_sub_object_code
  alias_method :encumbrance_project, :source_project_code
  alias_method :encumbrance_org_ref_id, :source_organization_reference_id
  alias_method :encumbrance_amount, :source_amount
  alias_method :encumbrance_line_description, :source_line_description

  action(:add_encumbrance_line) { |b| b.frm.button(alt: 'Add Encumbrance Accounting Line').click }

  #DISENCUMBRANCE
  alias_method :disencumbrance_chart_code, :target_chart_code
  alias_method :disencumbrance_account_number, :target_account_number
  alias_method :disencumbrance_sub_account, :target_sub_account_code
  alias_method :disencumbrance_object, :target_object_code
  alias_method :disencumbrance_sub_object, :target_sub_object_code
  alias_method :disencumbrance_project, :target_project_code

  #these two alias methods refer to the same data object
  alias_method :disencumbrance_org_ref_id, :target_organization_reference_id
  alias_method :disencumbrance_organization_reference_id, :disencumbrance_org_ref_id

  alias_method :disencumbrance_amount, :target_amount
  alias_method :disencumbrance_reference_number, :target_reference_number

  action(:add_disencumbrance_line) { |b| b.frm.button(alt: 'Add Disencumbrance Accounting Line').click }

  # Extended Attributes
  #ENCUMBRANCE
  #CU specific attributes
  element(:source_auto_dis_encumber_type) { |b| b.frm.select(name: 'newSourceLine.autoDisEncumberType') }
  alias_method :encumbrance_auto_dis_encumber_type, :source_auto_dis_encumber_type

  element(:source_partial_transaction_count) { |b| b.frm.text_field(name: 'newSourceLine.partialTransactionCount') }
  alias_method :encumbrance_count, :source_partial_transaction_count

  element(:source_start_date) { |b| b.frm.text_field(name: 'newSourceLine.startDate') }
  alias_method :encumbrance_start_date, :source_start_date

  element(:source_end_date) { |b| b.frm.text_field(name: 'newSourceLine.endDate.div') }
  alias_method :encumbrance_end_date, :source_end_date

  element(:source_partial_amount) { |b| b.frm.text_field(name: 'newSourceLine.partialAmount') }
  alias_method :encumbrance_partial_amount, :source_partial_amount

  #DISENCUMBRANCE
  #CU specific attribute
  alias_method :disencumbrance_line_description, :target_line_description

end
