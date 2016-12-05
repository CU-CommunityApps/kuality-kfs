module VoucherLinesMixin
  include AccountingLinesMixin
  extend AccountingLinesMixin

  def default_accounting_lines(opts={})
    {
        accounting_lines: {
            source: collection('VoucherLineObject'),
            target: collection('VoucherLineObject')
        },
        initial_lines:    [],
        immediate_import: true
    }.merge(opts)
  end

end
