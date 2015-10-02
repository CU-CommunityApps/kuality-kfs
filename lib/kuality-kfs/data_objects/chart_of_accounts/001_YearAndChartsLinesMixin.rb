module YearAndChartsLinesMixin

  # Include this mixin at the bottom of your class definition for best results.
  # Otherwise, the methods it extends may not be defined when the mixin is evaluated.
  # @param [Class] base_class Class that the mixin will be added to
  # @return [Class] Merged Class
  def self.included(base_class)
    base_class.class_eval do

      attr_accessor :initial_year_and_charts
      attr_reader :year_and_charts


      class << self
        def year_and_charts_mixin_attributes
          [:initial_year_and_charts, :year_and_charts]
        end
      end

      # @param [Array] year_chart_codes An array of Hashes representing an update to the @year_and_charts collection
      def year_and_charts=(year_chart_codes)
        # If we're initializing, copying or resetting, just take the collection as-is
        if year_chart_codes.instance_of? YearAndChartLineObjectCollection
          year_and_charts = year_chart_codes
          return
        end

        # Otherwise, we're adding or editing elements and we want a Hash.
        raise ArgumentError, 'All Year and Chart line updates must be supplied as Hashes!' unless year_chart_codes.all? {|element| element.is_a? Hash }

        # Load them in the prescribed order. If no number is provided, throw them at the end in the order given
        i = -1
        year_chart_codes.sort_by! { |element| element[:line_number].nil? ? (i+=1; year_chart_codes.length*2+i) : element[:line_number] }
        year_chart_codes.each do |item|
          case
            when item[:line_number].nil?, @year_and_charts.length == item[:line_number]
              @year_and_charts.add item # New line
            when @year_and_charts.length + 1 < item[:line_number]
              raise ArgumentError, "Can't add an Year and Chart with line number #{item[:line_number]} because there are only #{@year_and_charts.length} lines so far."
            else
              raise ArgumentError, "Can't edit a Year and Chart with line number #{item[:line_number]} because edit is not allowed."
          end
        end
      end

      def default_year_and_charts(opts={})
        # This just makes it so we don't have to be so repetitive. It can certainly be
        # overridden in a subclass if you don't want to chuck things in via opts.
        {
            year_and_charts:         collection('YearAndChartLineObject'),
            initial_year_and_charts: []
        }.merge(opts)
      end


      # back up methods to be extended. Use these instead of #super in the extended methods
      alias_method :super_post_create, :post_create
      # alias_method :super_edit, :edit
      alias_method :super_update_line_objects_from_page!, :update_line_objects_from_page!
      def post_create
        super_post_create
        @initial_year_and_charts.each{ |il| @year_and_charts.add il }
        @initial_year_and_charts = nil
      end

      #No edit of the data allowed on edoc after it is added; therefore, no edit method

      def update_line_objects_from_page!(target=:readonly)
        super_update_line_objects_from_page!
        @initial_year_and_charts.update_from_page! target
      end

    end
  end
end
