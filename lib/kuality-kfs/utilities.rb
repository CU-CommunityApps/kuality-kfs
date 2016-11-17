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

  # @return [String] A randomly-generated phone number that should pass KFS's requirements for phone numbers. No other assurances.
  def random_phone_number
    "#{rand(99..999)}-#{rand(99..999)}-#{rand(999..9999)}"
  end

  # @return [String] A randomly generated email address that should pass KFS's requirements for email address validation. No other assurances.
  def random_email_address
    "#{[*('a'..'z')].sample(6).join}" + '@abc.xyz'
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

  # @param [String] type Named type of Account to search for with the service
  # @return [String] The Account Number of the requested type if found by the service, or nil if not found
  def get_account_of_type(type)
    case type
      when 'Cost Sharing Account'
        ((get_kuali_business_objects('KFS-COA','Account',"chartOfAccountsCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}&accountTypeCode=CC&subFundGroup.fundGroupCode=CG&accountName=*cost share*&}")['org.kuali.kfs.coa.businessobject.Account']).sample)['accountNumber'][0]
      when 'Open Non-Expired Contracts & Grants Account'
        ((get_kuali_business_objects('KFS-COA','Account',"chartOfAccountsCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}&accountTypeCode=CC&subFundGroup.fundGroupCode=CG&subFundGroupCode=CGFEDL&closed=N&active=Y&accountExpirationDate=NULL&}")['org.kuali.kfs.coa.businessobject.Account']).sample)['accountNumber'][0]
      when 'Open Expired Contracts & Grants Account'
        all_open_expired_accounts = get_kuali_business_objects('KFS-COA',
                                                               'Account',
                                                               "chartOfAccountsCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}&accountTypeCode=CC&subFundGroup.fundGroupCode=CG&subFundGroupCode=CGFEDL&closed=N&active=N&")['org.kuali.kfs.coa.businessobject.Account']
        single_open_expired_account = all_open_expired_accounts.sample
        single_open_expired_account['accountNumber'][0]
      when 'Closed Contracts & Grants Account'
        ((get_kuali_business_objects('KFS-COA','Account',"chartOfAccountsCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}&accountTypeCode=CC&subFundGroup.fundGroupCode=CG&subFundGroupCode=CGFEDL&closed=Y&}")['org.kuali.kfs.coa.businessobject.Account']).sample)['accountNumber'][0]
      when 'Random Sub-Fund Group Code'
        get_kuali_business_object('KFS-COA','Account',"chartCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}&subFundGroupCode=*&extension.programCode=*&closed=N&extension.appropriationAccountNumber=*&active=Y&accountExpirationDate=NULL")['accountNumber'].sample
      else
        nil
    end
  rescue RuntimeError => re
    # In other cases, get_kuali_business_object will raise a RuntimeError if no results are found.
    nil
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