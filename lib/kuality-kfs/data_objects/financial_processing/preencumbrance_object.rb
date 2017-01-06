class PreEncumbranceObject < KFSDataObject

  include AccountingLinesMixin
  include PreEncumbranceLinesMixin

  DOC_INFO = { label: 'Pre-Encumbrance', type_code: 'PE', transactional?: true, action_wait_time: 60 }

  alias :add_disencumbrance_line :add_target_line
  alias :add_encumbrance_line :add_source_line
  alias :import_disencumbrance_lines :import_target_lines
  alias :import_encumbrance_line :import_source_lines

  attr_accessor   :organization_document_number, :explanation

  def defaults
    super.merge!(default_accounting_lines)
  end

  def build
    visit(MainPage).pre_encumbrance
    on PreEncumbrancePage do |page|
      page.expand_all
      page.description.focus
      page.alert.ok if page.alert.exists?
      fill_out page, :description, :organization_document_number, :explanation

      #FYI: Pre Encumbrance document needs to be saved before it can be submitted.
    end
  end
end
