class SalaryExpenseTransferObject < KFSDataObject

  include Utilities
  include GlobalConfig
  include SalaryExpenseTransferAccountingLinesMixin

  DOC_INFO = { label: 'Salary Expense Transfer Document', type_code: 'ST' }

  attr_accessor :fiscal_year, :employee_id,
                :actuals_balance_type, :labor_balance_typed, :debit_code, :credit_code, :period_unassigned,
                :remembered_employee_id

  def  defaults
    super.merge({
        employee_id:          get_aft_parameter_value(ParameterConstants::DEFAULT_ST_EMPL_ID),
        actuals_balance_type: 'AC',
        labor_balance_typed:  'A2',
        debit_code:           'D',
        credit_code:          'C',
        period_unassigned:    ''

    }).merge!(default_accounting_lines)

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

  def clear_global_attributes_to_be_used  #nkk4 move to mixin requested, do it on @accounting_lines so data is not duplicated
    @chart_code = nil
    @account_number = nil
    @sub_account_code = nil
    @object_code = nil
    @sub_object_code = nil
    @project_code = nil
    @organization_reference_id = nil
    @position_number = nil
    @payroll_end_date_fiscal_year = nil
    @payroll_end_date_fiscal_period_code = nil
    @payroll_total_hours = nil
    @amount = nil
    @fringe_benefit_inquiry = nil
  end

  def pull_specified_accounting_line(type, row, page)   #nkk4 move to the mixin for the accounting lines
    #required to ensure validity of data being used is from page
    clear_global_attributes_to_be_used

    if type == :source
      @chart_code = page.chart_code_value type, row
      @account_number = page.account_number_value type, row
      @sub_account_code = page.sub_account_number_value type, row
      @object_code = page.object_code_value type, row
      @sub_object_code = page.sub_object_code_value type, row
      @project_code = page.project_code_value type, row
      @organization_reference_id = page.organization_reference_id_value type, row
      @position_number = page.position_number_value type, row
      @payroll_end_date_fiscal_year = page.payroll_end_date_fiscal_year_value type, row
      @payroll_end_date_fiscal_period_code = page.payroll_end_date_fiscal_period_code_value type, row
      @payroll_total_hours = page.st_payroll_total_hours type, row
      @amount = page.st_amount type, row
      @fringe_benefit_inquiry = page.view_fringe_benefit_link type, row

    else #":target"
      @chart_code = page.st_chart_code type, row
      @account_number = page.st_account_number type, row
      @sub_account_code = page.st_sub_account_code type, row
      @object_code = page.st_object_code type, row
      @sub_object_code = page.st_sub_object_code type, row
      @project_code = page.st_project_code type; row
      @organization_reference_id = page.st_organization_reference_id type, row
      @position_number = page.position_number_value type, row
      @payroll_end_date_fiscal_year = page.payroll_end_date_fiscal_year_value type, row
      @payroll_end_date_fiscal_period_code = page.payroll_end_date_fiscal_period_code_value type, row
      @payroll_total_hours = page.st_payroll_total_hours type, row
      @amount = page.st_amount type, row
      @fringe_benefit_inquiry = page.view_fringe_benefit_link type, row
    end

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


  # NOTE: percent value is stored in database as a whole number
  #       i.e. 25.00% and does not have decimal representation of .25
  def calculate_benefit_amount(amount, percentage_as_whole_number)

    percent = percentage_as_whole_number.to_f / 100.0  #get into percent

    #to round i.e. want 10% of 22.79 ==> ((22.79 * .1)*100).round / 100.0 = 2.28
    benefit_amount = (((amount).to_f * percent.to_f) * 100.0).round / 100.0
    return benefit_amount
  end


  def llpe_line_matches_accounting_line_data(llpe_account, llpe_object, llpe_amount, llpe_period, llpe_balance_type,
                               llpe_debit_credit_code, account, object, amount, period, balance_type, debit_credit_code)

    #return true only when all input parameters match;
    # period values could be zero length strings; amounts could be floats; rest should be string values
    if (llpe_account == account) && (llpe_object == object) && (llpe_amount.to_s == amount.to_s) &&
       (llpe_balance_type == balance_type) && (llpe_debit_credit_code == debit_credit_code) &&
       ( (llpe_period.empty? && period.empty?) || (!llpe_period.empty? && !period.empty? && llpe_period == period)  )
      return true
    else
      return false
    end
  end

end
