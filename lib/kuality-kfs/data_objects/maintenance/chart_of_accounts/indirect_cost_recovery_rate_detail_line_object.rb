class IndirectCostRecoveryRateDetailLineObject < DataFactory

  attr_accessor :line_number, :chart_code, :account_number, :sub_account_number,
                :object_code, :sub_object_code, :debit_credit_code, :percent, :details_active_indicator


  # Class Constants
  DEBIT_WILDCARD  = '@'
  CREDIT_WILDCARD = '#'


  def initialize(browser, opts={})
    @browser = browser

    defaults = { details_active_indicator: :set }

    set_options(defaults.merge(opts))
  end


  def add_new(opts={})
      on IndirectCostRecoveryRatePage do |page|
        page.chart_code.fit             opts[:chart_code]
        page.account_number.fit         opts[:account_number]
        page.sub_account_number.fit     opts[:sub_account_number]
        page.object_code.fit            opts[:object_code]
        page.object_code.fit            opts[:sub_object_code]
        page.debit_credit_code.select   opts[:debit_credit_code]
        page.percent.fit                opts[:percent]
        fill_out_extended_attributes
        page.add_icr_rate_detail
      end

  end


  def fill_out_extended_attributes
    # Override this method if you have site-specific extended attributes.
  end
end


class IndirectCostRecoveryRateDetailLineObjectCollection < LineObjectCollection

  contains IndirectCostRecoveryRateDetailLineObject

  # @param [Fixnum] i The line number to look for (zero-based)
  # @param [Symbol] target Which contact to pull from (most useful during a copy action). Defaults to :new
  # @return [Hash] The return values of attributes for the given line
  def pull_existing_detail(i=0, target=:new)
    pulled_detail = Hash.new

    on IndirectCostRecoveryRatePage do |page|
      case target
        when :new
          pulled_detail = {
              line_number:                page.line_number_readonly(i),
              chart_code:                 page.chart_code_readonly(i),
              account_number:             page.account_number_readonly(i),
              sub_account_number:         page.sub_account_number_readonly(i),
              object_code:                page.object_code_readonly(i),
              sub_object_code:            page.sub_object_code_readonly(i),
              debit_credit_code:          page.debit_credit_code_readonly(i),
              percent:                    page.percent_readonly(i)
              #details_active_indicator:   yesno2setclear(page.details_active_indicator_readonly(i).value)
          }
      end
    end

    pulled_detail
  end

end