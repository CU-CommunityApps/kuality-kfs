class SalaryExpenseTransferObject < KFSDataObject

  include Utilities
  include GlobalConfig
  include SalaryExpenseTransferAccountingLinesMixin

  DOC_INFO = { label: 'Salary Expense Transfer Document', type_code: 'ST' }

  attr_accessor :fiscal_year, :employee_id

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        description: random_alphanums(20, 'AFT'),
        employee_id: get_aft_parameter_value(ParameterConstants::DEFAULT_ST_EMPL_ID)
    }.merge!(default_accounting_lines)

    set_options(defaults.merge(opts))
  end

  def build
    visit(MainPage).salary_expense_transfer
    on SalaryExpenseTransferPage do |page|
      page.expand_all
      page.description.focus
      page.alert.ok if page.alert.exists? # Because, y'know, sometimes it doesn't actually come up...
      fill_out page, :description, :employee_id
    end
  end


  def search_for_employee
    on(SalaryExpenseTransferPage) do |page|
      #look back to previous fiscal year at start of new fiscal year because we do not have labor data yet
      if fiscal_period_conversion(right_now[:MON]).to_i < 2
        @fiscal_year = page.fiscal_year.value.to_i - 1
        page.fiscal_year.set @fiscal_year
      end
      page.import_search
    end
  end

  def retrieve_first_positive_balance_month
    on LedgerBalanceLookupPage do |lblookup|
      #TODO Change to select first month with a positive balance.  Currently, first month regardless of balance is being selected.
      lblookup.check_first_month
      lblookup.return_selected
    end

  end

  def pull_specified_accounting_line(type, row, page)
    @chart_code = page.chart_code_value type; row
    @account_number = page.account_number_value type; row
    @sub_account_code = page.sub_account_number_value type; row
    @object_code = page.object_code_value type; row
    @sub_object_code = page.sub_object_code_value type; row
    @project_code = page.project_code_value type; row
    @organization_reference_id = page.organization_reference_id_value type; row
    @position_number = page.position_number_value type; row
    @payroll_end_date_fiscal_year = page.payroll_end_date_fiscal_year_value type; row
    @payroll_end_date_fiscal_period_code = page.payroll_end_date_fiscal_period_code_value type; row
    @payroll_total_hours = page.payroll_total_hours type; row
    @amount = page.salary_expense_amount type; row
    @fringe_benefit_inquiry = page.view_fringe_benefit_link
    new_line = {
      :chart_code                           => @chart_code,
      :account_number                       => @account_number,
      :sub_account_code                     => @sub_account_code,
      :object_code                          => @object_code,
      :sub_object_code                      => @sub_object_code,
      :project_code                         => @project_code,
      :organization_reference_id            => @organization_reference_id,
      :position_number                      => @position_number,
      :payroll_end_date_fiscal_year         => @payroll_end_date_fiscal_year,
      :payroll_end_date_fiscal_period_code  => @payroll_end_date_fiscal_period_code,
      :payroll_total_hours                  => @payroll_total_hours,
      :fringe_benefit_inquiry               => @fringe_benefit_inquiry,
      :amount                               => @amount
    }
    return new_line
  end


  def get_fringe_benefit_detail(link)
    fringe_detail = {}
    link.click
    sleep 10
    on FringeBenefitInquiryPage do |fbpage|
      fbpage.use_new_tab
      #only one row in table, collection not used to keep it simple
      fbpage.fringe_benefit_detail_table.rest.each do |row|
        fringe_detail = {
          :fringe_benefit_object_code  => row[fbpage.fringe_benefit_detail_table.keyed_column_index(:object_code)].text,
          :fringe_benefit_amount       => row[fbpage.fringe_benefit_detail_table.keyed_column_index(:amount)].text
        }
      end
      return fringe_detail
    end
  end



  def lookup_labor_benefits_type_code(chart_code, object_code)
    on LaborObjectCodeBenefitsLookupPage do |lobpage|
      lobpage.use_new_tab
      lobpage.universityFiscalYear.set @fiscal_year
      lobpage.chart_code.set chart_code
      lobpage.object_code.set object_code
      lobpage.search
      lobpage.find_item_in_table
    end
  end

end
