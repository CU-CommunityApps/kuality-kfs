module AccountingLinesMixin

  attr_accessor :accounting_lines, :initial_lines

  def default_accounting_lines(opts={})
    # This just makes it so we don't have to be so repetitive. It can certainly be
    # overridden in a subclass if you don't want to chuck things in via opts.
    {
        accounting_lines: {
            source: collection('AccountingLineObject'),
            target: collection('AccountingLineObject')
        },
        initial_lines:    []
    }.merge(opts)
  end

  def post_create
    super
    @initial_lines.each{ |il| add_line((il[:type].nil? ? :source : il[:type]), il) }
  end

  def add_line(type, al)
    @accounting_lines[type].add(al.merge({type: type}))
  end

  def add_target_line(al)
    add_line(:target, al)
  end

  def add_source_line(al)
    add_line(:source, al)
  end

  # This seems to be the best way to shorten the repeated information in the
  # import_lines method and makes the method call make more symantic sense.
  def import_lines(type, file_name)
    @accounting_lines[type].import_lines(type, file_name)
  end

  def import_source_lines(file_name)
    import_lines(:source, file_name)
  end

  def import_target_lines(file_name)
    import_lines(:target, file_name)
  end

end

module BudgetAdjustmentLinesMixin
  include AccountingLinesMixin
  extend AccountingLinesMixin

  def default_accounting_lines(opts={})
    {
        accounting_lines: {
            source: collection('BudgetAdjustmentLineObject'),
            target: collection('BudgetAdjustmentLineObject')
        },
        initial_lines:    []
    }.merge(opts)
  end

end

module VoucherLinesMixin
  include AccountingLinesMixin
  extend AccountingLinesMixin

  def default_accounting_lines(opts={})
    {
        accounting_lines: {
            source: collection('VoucherLineObject'),
            target: collection('VoucherLineObject')
        },
        initial_lines:    []
    }.merge(opts)
  end

end