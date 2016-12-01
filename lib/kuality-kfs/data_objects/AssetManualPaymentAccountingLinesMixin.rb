module AssetManualPaymentAccountingLinesMixin
  include AccountingLinesMixin
  extend AccountingLinesMixin

  def default_accounting_lines(opts={})
    {
        accounting_lines: {
            source: collection('AssetManualPaymentAccountingLineObject')
            #there are no target lines on this edoc
        },
        initial_lines:    [],
        immediate_import: true
    }.merge(opts)
  end
end
