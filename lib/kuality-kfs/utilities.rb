module Utilities

  include StringFactory

  def get(item)
    instance_variable_get(snakify(item))
  end

  def set(item, obj)
    instance_variable_set(snakify(item), obj)
  end

  def snake_case(string)
    StringFactory.damballa(string)
  end

  def document_object_for(document)
    get(snake_case(document))
  end

  def document_object_of(klass)
    klass.to_s.gsub(/(?<=[a-z])(?=[A-Z])/, ' ').sub(/(.*) (Object)$/, '\1')
  end

  def object_class_for(document)
    Kernel.const_get("#{snake_case(document).to_s.split('_').map(&:capitalize).join('')}Object")
  end

  def page_class_for(document)
    Kernel.const_get("#{snake_case(document).to_s.sub(/[oO]bject$/, '').split('_').map(&:capitalize).join('')}Page")
  end

  def generate_random_account_delegate_account_number
    random_alphanums(7)
  end

  def generate_random_account_delegate_model_name
    random_alphanums(10, 'AFT')
  end

  def generate_random_account_name
    random_alphanums(15, 'AFT')
  end

  def generate_random_account_number
    (random_alphanums(7)).upcase!
  end

  def generate_random_address
    "#{rand(1..9999)} Evergreen Terrace"
  end

  def generate_random_city
    random_letters(10)
  end

  def generate_random_description
    random_alphanums(40, 'AFT')
  end

  # @return [String] A randomly generated email address that should pass KFS's requirements for email address validation. No other assurances.
  def generate_random_email_address
    "#{[*('a'..'z')].sample(6).join}" + '@abc.xyz'
  end

  def generate_random_financial_object_code_description
    random_alphanums(60, 'AFT')
  end

  def generate_random_indirect_cost_recovery_rate_id
    random_alphanums(3)
  end

  def generate_random_object_code
    random_alphanums(4)
  end

  def generate_random_object_code_name
    random_alphanums(10, 'AFT')
  end

  def generate_random_object_code_short_name
    random_alphanums(5, 'AFT')
  end

  # @return [String] A randomly generated phone number that should pass KFS's requirements for phone numbers. No other assurances.
  def generate_random_phone_number
    "#{rand(99..999)}-#{rand(99..999)}-#{rand(999..9999)}"
  end

  def generate_random_sub_account_name
    random_alphanums(40)
  end

  def generate_random_sub_account_number
    random_alphanums(7)
  end

  def generate_random_sub_object_code_name
    random_alphanums(20, 'AFT')
  end

  def generate_random_sub_object_code_short_name
    random_alphanums(5, 'ATF')
  end

  def generate_invalid_appropriation_account_number
    random_alphanums(6, 'XX').upcase
  end

  def generate_invalid_major_reporting_category_code
    random_alphanums(6, 'XX').upcase
  end

  def generate_invalid_organization_code
    'BSBS'
  end

  def generate_invalid_sub_fund_program_code
    random_alphanums(4, 'XX').upcase
  end


  def fiscal_period_conversion(month)
    case month
      when 'JAN', 'Jan', 'January'
        '07'
      when 'FEB', 'Feb', 'February'
        '08'
      when 'MAR', 'Mar', 'March'
        '09'
      when 'APR', 'Apr', 'April'
        '10'
      when 'MAY', 'May'
        '11'
      when 'JUN', 'Jun', 'June'
        '12'
      when 'JUL', 'Jul', 'July'
        '01'
      when 'AUG', 'Aug', 'August'
        '02'
      when 'SEP', 'Sep', 'September'
        '03'
      when 'OCT', 'Oct', 'October'
        '04'
      when 'NOV', 'Nov', 'November'
        '05'
      when 'DEC', 'Dec', 'December'
        '06'
      else
        # We'll do a recursive conversion if we have to. On the second-time through,
        # we can be assured that the String length is 3 and will match something above
        # if the conversion is good.
        fail ArgumentError, 'Bad Fiscal Period conversion!' if month.length == 3
        fiscal_period_conversion(month[:MON]) # This may throw other errors, but that's ok.
    end
  end

  def yesno2setclear(value)
    case value.to_s.upcase
      when 'YES', 'ON', 'TRUE'
        :set
      when 'NO', 'OFF', 'FALSE'
        :clear
      else
        nil
    end
  end

  private

  def snakify(item)
    item.to_s[0]=='@' ? item : "@#{snake_case(item.to_s)}"
  end

  # @param  Money amount in US dollars and cents. This value will be converted to a string and then to an integer.
  # @return [Integer] Money amount converted to an integer represented as US cents.
  def to_cents_i(amount)
    ((amount).to_s.delete(",")).to_i * 100
  end

end
