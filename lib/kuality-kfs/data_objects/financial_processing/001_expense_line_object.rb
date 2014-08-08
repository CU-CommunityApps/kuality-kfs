class ExpenseLineObject < DataFactory

  include DateFactory
  include StringFactory
  include GlobalConfig

  attr_accessor   :line_number,
                  :name, :department_code,
                  :req_instate, :amount

  def defaults
    Hash.new
  end

  def initialize(browser, opts={})
    @browser = browser
    set_options(defaults.merge(opts))
  end

  def create
    on PrePaidTravelExpensesTab do |tab|
      tab.show_pre_paid_travel_expense_tab unless tab.pre_paid_travel_expense_tab_shown?
      fill_out tab, :name, :department_code, :req_instate, :amount
    end

    fill_out_extended_attributes

    on(PrePaidTravelExpensesTab).add_pre_paid_expense
  end

  def edit(opts={})
    on PrePaidTravelExpensesTab do |tab|
      tab.update_update_name(@line_number).fit opts[:update_name]
      tab.update_update_department_code(@line_number).fit opts[:update_department_code]
      tab.update_req_instate(@line_number).fit opts[:update_req_instate]
      tab.update_amount(@line_number).fit opts[:update_amount]
    end
    update_extended_attributes(opts)
    update_options(opts)
  end

  def delete
    on(PrePaidTravelExpensesTab).delete_pre_paid_expense(@line_number)
  end

  def fill_out_extended_attributes
    # Override this method if you have site-specific extended attributes.
  end

  def update_extended_attributes(opts = {})
    # Override this method if you have site-specific extended attributes.
  end
  alias_method :edit_extended_attributes, :update_extended_attributes

end

class ExpenseLineObjectCollection < LineObjectCollection

  contains ExpenseLineObject

  def edit(opts=[])
    if length > 0
      opts.each do |opt|
        if opt[:line_number].nil?
          self << (create contained_class, opt.merge(line_number: length)) # New. Tack it on at the end.
        else
          # Update. Edit directly.
          opt.delete(:line_number)
          self[opt[:line_number]].edit opt
        end
      end
    else
      opts.each{ |opt| self << (create contained_class, opt.merge(line_number: length)) } # All new.
    end
  end

  def update_from_page!
    on PrePaidTravelExpensesTab do |lines|
      clear # Drop any cached lines. More reliable than sorting out an array merge.

      unless lines.current_expenses_count.zero?
        (0..(lines.current_expenses_count - 1)).to_a.collect!{ |i|
          # Update the stored lines.
          self << (create contained_class, line_number: i)
        }
      end

    end
  end

end