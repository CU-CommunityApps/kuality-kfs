class AuxiliaryVoucherObject < KFSDataObject

  include VoucherLinesMixin
  alias :add_target_line :add_source_line

  DOC_INFO = { label: 'Auxiliary Voucher', type_code: 'AV', transactional?: true, action_wait_time: 30 }

  attr_accessor :organization_document_number, :explanation,
                :accounting_period,
                :auxiliary_voucher_type_adjustment, :auxiliary_voucher_type_accrual, :auxiliary_voucher_type_recode


  def default_lines(opts={})
    super(opts).merge(
        initial_lines: [{
                            type:           :source,
                            chart_code:     '',
                            account_number: '',
                            object:         '',
                            current_amount: ''
                        }])
  end


  def defaults
    super.merge!(default_accounting_lines)
         .merge(get_aft_parameter_values_as_hash(ParameterConstants::DEFAULTS_FOR_AUXILIARY_VOUCHER))

  end

  def build
    visit(MainPage).auxiliary_voucher
    on AuxiliaryVoucherPage do |page|
      page.expand_all
      page.description.focus
      page.alert.ok if page.alert.exists? # Because, y'know, sometimes it doesn't actually come up...
      fill_out page, :description, :organization_document_number, :explanation
    end
  end

end