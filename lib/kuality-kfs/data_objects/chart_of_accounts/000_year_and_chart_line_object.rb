class YearAndChartLineObject < DataFactory

  attr_accessor   :line_number,
                  :fiscal_year,
                  :chart_of_accounts_code

  def defaults
    Hash.new
  end

  def initialize(browser, opts={})
    @browser = browser
    set_options(defaults.merge(opts))
  end

  # @return [Hash] Hash that can be used for serialization
  def to_hash
    Hash[self.class.attributes.zip(self.class.attributes.collect { |attr| (self.send(attr)) })]
  end

  def create
    on EditMultipleYearAndChartTab do |year_chart_tab|
      fill_out year_chart_tab, :fiscal_year, :chart_of_accounts_code
      fill_out_extended_attributes
      year_chart_tab.add_year_and_chart_code
    end
  end

  #No edit of the data allowed on edoc after it is added; therefore, no edit method

  def delete
    on(EditMultipleYearAndChartTab).delete_year_and_chart_code(@line_number)
  end

  def fill_out_extended_attributes
    # Override this method if you have site-specific extended attributes.
  end

  def edit_extended_attributes(opts = {})
    # Override this method if you have site-specific extended attributes.
  end

end

class YearAndChartLineObjectCollection < LineObjectCollection

  contains YearAndChartLineObject


  # @return [Hash] Hash of ordered Arrays of Hashes that can be used for serialization
  def to_hash
    {
        year_and_charts: collect { |year_chart| year_chart.to_hash }
    }
  end

  # @param [Symbol] target Which Year and Chart to pull from (most useful during a copy action). Defaults to :readonly as this is the only value allowed on the tab
  def update_from_page!(target=:readonly)
    clear # Drop any cached lines. More reliable than sorting out an array merge.

    updates = updates_pulled_from_page(target)
    unless updates.nil?
      updates.each do |new_obj|
        # Update the stored lines
        self << (make contained_class, new_obj)
      end
    end
  end

  # @param [Symbol] target Which Year and Chart to pull from (most useful during a copy action). Defaults to :readonly as this is the only value allowed on the tab
  # @return [Array] Array of Hashes representing the updates that were pulled, or nil if none were found.
  def updates_pulled_from_page(target=:readonly)
    on EditMultipleYearAndChartTab do |year_chart_tab|
      year_chart_tab.show_multiple_year_and_chart unless year_chart_tab.multiple_year_and_chart_tab_shown?
      if year_chart_tab.current_year_and_chart_count.zero?
        return nil
      else
        return (0..(year_chart_tab.current_year_and_chart_count - 1)).to_a
        .collect!{ |i|
          {line_number: i}.merge(pull_existing_year_and_chart(i, target))
          .merge(pull_extended_existing_year_and_chart(i, target))
        }
      end
    end
  end

  # @param [Fixnum] i The line number to look for (zero-based)
  # @param [Symbol] target Which ICR Account to pull from (most useful during a copy action). Defaults to :readonly as this is the only value allowed on the tab
  # @return [Hash] The return values of attributes for the given line
  def pull_existing_year_and_chart(i=0, target=:readonly)
    pulled_year_and_chart = Hash.new

    on EditMultipleYearAndChartTab do |year_chart_tab|
      case target
        when :readonly
          pulled_year_and_chart = {
              fiscal_year:            year_chart_tab.send("fiscal_year_#{target}", i),
              chart_of_accounts_code: year_chart_tab.send("chart_of_accounts_code_#{target}", i)
          }
        else
          raise ArgumentError, "YearAndChartLineObject does not know how to pull the provided line type (#{target})!"
      end
    end

    pulled_year_and_chart
  end

  # @param [Fixnum] i The line number to look for (zero-based)
  # @param [Symbol] target Which address to pull from (most useful during a copy action). Defaults to :readonly as this is the only value allowed on the tab
  # @return [Hash] The return values of attributes for the given line
  def pull_extended_existing_year_and_chart(i=0, target=:readonly)
    # This can be implemented for site-specific attributes. See the Hash returned in
    # the #collect! in #update_from_page! above for the kind of way to get the
    # right return value.
    Hash.new
  end

end
