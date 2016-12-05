module KsbClientUtilities

  def ksb_client
    rice_url = ENV['RICE_URL'] ? ENV['RICE_URL'] : global_config[:rice_url]
    @@ksb_client ||= KSBServiceClient.new("#{File.dirname(__FILE__)}/../../features/support/client-sign.properties", "cynergy-dev", rice_url.sub(/(\/)+$/,''))
  end

  def role_service
    @@role_service ||= ksb_client.getRoleService()
  end

  def identity_service
    @@identity_service ||= ksb_client.getIdentityService()
  end

  def group_service
    @@group_service ||= ksb_client.getGroupService()
  end

  def state_service
    @@state_service ||= ksb_client.getStateService()
  end

  def postal_code_service
    @@postal_code_service ||= ksb_client.getPostalCodeService()
  end

  def parameter_service
    @@parameter_service ||= ksb_client.getParameterService()
  end

  def permission_service
    @@permission_service ||= ksb_client.getPermissionService()
  end

  def workflow_document_service
    @@workflow_document_service ||= ksb_client.getWorkflowDocumentService()
  end

  # Use this method to obtain any AFT specific parameter that has its value defined as containing multiple attribute
  # key=value value pairs separated by semicolons. This method will return a hash of those key-value pairs.
  # @param [String] parameter_name Defined constant from module ParameterConstants
  # @return [Hash] Key-Value pairs where key is name of the class attribute and value is value that it should have.
  def get_aft_parameter_values_as_hash(parameter_name)
    h = {}
    perform_aft_parameter_retrieval(parameter_name).each do |key_val_pair|
      k,v = key_val_pair.split('=')
      h[k.to_sym] = v
    end
    h
  end

  # Use method to obtain any AFT specific parameter that has its value defined for a single attribute.
  # @param [String] parameter_name Defined constant from module ParameterConstants
  # @return [String] String representing the value defined in the application for the parameter.
  def get_aft_parameter_value(parameter_name)
    perform_aft_parameter_retrieval(parameter_name)[0]
  end

  # returns a list of assignees for a group
  def get_permission_assignees_by_template(namespace_code, template_name, permission_details)
    key, value = permission_details.first
    perm_details_list = StringMapEntryListType.new
    perm_detail = StringMapEntryType.new
    perm_detail.key = key.to_s
    perm_detail.value = value.to_s
    perm_details_list.entry.add(perm_detail)
    permission_service.getPermissionAssigneesByTemplate(namespace_code, template_name, perm_details_list, StringMapEntryListType.new).assignee
  end

  def get_random_principal_id_with_phone_number_for_role(name_space, role_name)
    phone_number = nil
    pid = nil
    while phone_number.nil? || phone_number.empty?
      pid = get_random_principal_id_for_role(name_space, role_name)
      phone_number = identity_service.getEntityByPrincipalId(pid)
                         .getEntityTypeContactInfos().getEntityTypeContactInfo().get(0)
                         .getPhoneNumbers().getPhoneNumber().get(0)
                         .getPhoneNumber()
    end
    pid
  end

  def get_document_initiator(document_type)
    permission_details = {'documentTypeName' => document_type}
    assignees = get_permission_assignees_by_template('KR-SYS', 'Initiate Document', permission_details).to_a
    if assignees.any?
      principal_id = assignees.delete_if{ |assignee| assignee.principalId == '2'}.sample.principalId
      person = identity_service.getEntity(principal_id)
      person.principals.principal.to_a.sample.principalName
    else
      get_principal_names_for_role('KFS-SYS', 'Manager').sample
    end
  end

  def get_random_state_code
    states = state_service.findAllStatesInCountry('US')
    states.get_state.to_a.sample.get_code
  end

  def get_random_postal_code(state)
    if state.nil?
      state_to_search = 'NY'
    else
      state_to_search = state
    end
    postal_codes = postal_code_service.findAllPostalCodesInCountry('US')
    if state_to_search == '*'
      postal_codes.get_postal_code.to_a.sample.code
    else
      postal_codes.get_postal_code.to_a.find_all{ |postal_code| postal_code.state_code == state_to_search}.sample.code
    end
  end

  def get_random_capital_asset_object_code
    get_kuali_business_object('KFS-COA', 'ObjectCode', "universityFiscalYear=#{get_aft_parameter_value(ParameterConstants::CURRENT_FISCAL_YEAR)}&financialObjectSubTypeCode=CM&financialObjectTypeCode=EE&chartOfAccountsCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}")['financialObjectCode'][0]
  end

  def get_random_capital_asset_number
    get_kuali_business_object('KFS-CAM','Asset',"active=true&capitalAssetTypeCode=A&inventoryStatusCode=A&conditionCode=E&campusCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}")['capitalAssetNumber'].sample
  end

  def get_random_account_for_pre_encumbrance
    get_kuali_business_object('KFS-COA','Account',"chartOfAccountsCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}&accountName=*EXPENSE*&fundGroup=GN&closed=N&accountExpirationDate=NULL")
  end

  def get_random_account
    get_kuali_business_object('KFS-COA','Account',"chartOfAccountsCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}&closed=N&accountExpirationDate=NULL&active=Y")
  end

  def get_random_account_number
    get_random_account['accountNumber'][0]
  end

  # All ObjectCodeObject attributes are obtained and returned
  def get_random_object_code_object(object_sub_type_code='')
    get_kuali_business_object('KFS-COA', 'ObjectCode', "universityFiscalYear=#{get_aft_parameter_value(ParameterConstants::CURRENT_FISCAL_YEAR)}&chartOfAccountsCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}&financialObjectSubTypeCode=#{object_sub_type_code}&active=Y")
  end

  # Only the four character object code value is returned from the call to get all of a random object code object's attributes
  def get_random_object_code(object_sub_type_code='')
    get_random_object_code_object(object_sub_type_code)['financialObjectCode'][0]
  end

  # All ObjectCodeObject attributes for a pre-encumbrance object code are obtained and returned
  def get_random_object_code_object_for_pre_encumbrance
    get_kuali_business_object('KFS-COA', 'ObjectCode', "universityFiscalYear=#{get_aft_parameter_value(ParameterConstants::CURRENT_FISCAL_YEAR)}&financialObjectCodeName=Supplies*&active=Y&financialObjectTypeCode=EX&chartOfAccountsCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}")
  end

  # Only the four character object code value is returned from the call to get all of a random pre-encumbrance object code object's attributes
  def get_random_object_code_for_pre_encumbrance
    get_random_object_code_object_for_pre_encumbrance['financialObjectCode'][0]
  end

  def find_cg_accounts_in_cg_responsibility_range(lower_limit, upper_limit)
    responsibility_criteria = (lower_limit..upper_limit).to_a.join('|') #get all numeric values in range separated by pipe  (1..3)=1|2|3
    accounts_hash = get_kuali_business_objects('KFS-COA','Account',"chartOfAccountsCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}&subFundGroup.fundGroupCode=CG&closed=N&active=Y&accountExpirationDate=NULL&contractsAndGrantsAccountResponsibilityId=#{responsibility_criteria}")
    # The webservice returns the data in two different formats depending upon whether there is one Account found
    # or there are multiple Accounts found. We need to deal with both cases and we need to deal with condition of
    # no data at all returned.
    account_numbers = []
    if accounts_hash.empty?  #no data found
      raise RuntimeError, "No CG Accounts with CG Account Responsibility ID in range #{lower_limit} to #{upper_limit} found."
    elsif accounts_hash.has_key?('org.kuali.kfs.coa.businessobject.Account')  # multiple accounts found
      accounts_array = accounts_hash['org.kuali.kfs.coa.businessobject.Account']
      # web service can return an overwhelming amount of data, only take up to a max number
      # value is used more than once so make one call and reuse locally
      max_rows = (get_aft_parameter_value(ParameterConstants::DEFAULT_MAX_NUM_DATA_ROWS_TO_USE)).to_i
      number_of_elements = accounts_array.length > max_rows ? max_rows : accounts_array.length
      accounts_array.first(number_of_elements).each{ |value|
        account_numbers.concat(value['accountNumber'])
      }
    else #single Account found
      account_numbers.concat(accounts_hash['accountNumber'])
    end
    account_numbers
  end

  def find_random_cg_account_number_having(open_closed_ind, expired_non_expired_ind)
    random_account_number = ''
    case open_closed_ind
      when 'open'
        case expired_non_expired_ind
          when 'expired'
            random_account_number = get_account_of_type('Open Expired Contracts & Grants Account')
          when 'non-expired'
            random_account_number = get_account_of_type('Open Non-Expired Contracts & Grants Account')
          else
            fail ArgumentError, 'Expired or Non-Expired Contracts and Grants Account not specified, do not know which type of data to retrieve.'
        end
      when 'closed'
        random_account_number = get_account_of_type('Closed Contracts & Grants Account')

        #we need to remember the account number used in order to dynamically construct the error message that will be generated.
        @closed_account_number_used_for_icr_account_number = random_account_number
      else
        fail ArgumentError, 'Open or Closed Contracts and Grants Account not specified, do not know which type of data to retrieve.'
    end
    random_account_number
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

  def get_random_restricted_vendor_number
    get_kuali_business_object('KFS-VND','VendorDetail',"activeIndicator=Y&vendorRestrictedIndicator=Y&vendorParentIndicator=Y&vendorDunsNumber=NULL")['vendorNumber'].sample
  end

  # Obtain all active accounts for the specified organization code.
  # @param [String] organization_code
  # @return [Hash] Accounts that were found for specified organization code.
  def get_all_active_accounts_for_organization_code(organization_code)
    accounts_hash = get_kuali_business_objects('KFS-COA','Account',"organizationCode=#{organization_code}&closed=N")
    accounts_hash['org.kuali.kfs.coa.businessobject.Account']
  end

  # @return [String] An active, non-expired account number for an account possessing the specified parameter values as attributes.
  def get_account_number_for_cost_share_sub_account_with_sub_fund_group_code(cost_share_sub_fund_group_code, chart_code)
    get_kuali_business_object('KFS-COA','Account',"subFundGroupCode=#{cost_share_sub_fund_group_code}&active=Y&accountExpirationDate=NULL&chartOfAccountsCode=#{chart_code}")['accountNumber'].sample
  end

  # @return [String] Principal name of the fiscal officer assigned to the requested sub-account.
  def get_fiscal_officer_principal_name_for_sub_account_number(sub_account_account_number)
    account = get_kuali_business_object('KFS-COA','Account',"accountNumber=#{sub_account_account_number}")
    account['accountFiscalOfficerUser.principalName'][0]
  end

  # @return [boolean] True if object_code_to_verify is found; otherwise false
  def does_object_code_exist_for_current_fiscal_and_default_chart?(object_code_to_verify)
    # WebService will generate a RuntimeError when the object code value being looked up is not found; that condition
    # means the object code value does not currently exist and would be unique if it were to be added to the database.
    exists = true
    begin
      get_kuali_business_object('KFS-COA', 'ObjectCode', "universityFiscalYear=#{get_aft_parameter_value(ParameterConstants::CURRENT_FISCAL_YEAR)}&chartOfAccountsCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}&financialObjectCode=#{object_code_to_verify}&active=B")
    rescue RuntimeError
      exists = false
    end
    exists
  end

  # @return [Hash] Single account object with attributes that match the requested criteria.
  def find_open_active_account_with_random_subFundGroupCode_programCode_appropriationAccountNumber
    get_kuali_business_object('KFS-COA','Account','subFundGroupCode=*&extension.programCode=*&closed=N&extension.appropriationAccountNumber=*&active=Y&accountExpirationDate=NULL')
  end

  # @return [String] Random major reporting category code.
  def find_random_active_major_reporting_category_code
    get_kuali_business_object('KFS-COA','MajorReportingCategory','active=Y')['majorReportingCategoryCode'].sample
  end

  # @return [String] Parameter value defined in the application for the labor benefit clearing account number.
  def get_benefits_clearing_account_parameter_value
    (get_parameter_values('KFS-LD', 'BENEFIT_CLEARING_ACCOUNT_NUMBER', 'SalaryExpenseTransfer'))[0]
  end

  # @return [Hash] Parameter value(s) defined in the application for object sub-types restricted from use on the auxiliary voucher.
  def get_auxiliary_voucher_object_sub_types_parameter_value
    get_parameter_values('KFS-FP', 'OBJECT_SUB_TYPES', component_code='AuxiliaryVoucher')

  end

  # @return [Hash] Parameter value(s) defined in the application for object levels restricted from use on the auxiliary voucher.
  def get_auxiliary_voucher_object_levels_parameter_value
    get_parameter_values('KFS-FP', 'OBJECT_LEVELS', component_code='AuxiliaryVoucher')
  end

  # Account Lookup webservice call to obtain account object attributes.
  # @param [String] account_number
  # @param [String] closed_indicator
  # return [Hash] Hash of attributes representing the account object requested.
  def lookup_account_by(account_number, closed_indicator='N')
    get_kuali_business_object('KFS-COA','Account',"closed=#{closed_indicator}&accountNumber=#{account_number}")
  end

  # Labor Object Code Benefits Lookup as webservice call to obtain class object attributes.
  # @param [String] object_code
  # @param [String] fiscal_year
  # @param [String] chart_code
  # @return [Hash] Hash of attributes representing the labor object code benefits object requested.
  def lookup_labor_object_code_benefits_by(object_code, fiscal_year, chart_code)
    get_kuali_business_object('KFS-LD','PositionObjectBenefit',"universityFiscalYear=#{fiscal_year}&chartOfAccountsCode=#{chart_code}&financialObjectCode=#{object_code}")
  end

  # Labor Object Code Benefits Lookup as webservice call to obtain class object attributes.
  # @param [String] labor_benefits_rate_category_code
  # @param [String] labor_benefits_type_code
  # @param [String] fiscal_year
  # @param [String] chart_code
  # @return [Hash] Hash of attributes representing the labor benefits calculation object requested.
  def lookup_labor_benefits_calculation_by(labor_benefits_rate_category_code, labor_benefits_type_code, fiscal_year, chart_code)
    get_kuali_business_object('KFS-LD','BenefitsCalculation',"universityFiscalYear=#{fiscal_year}&chartOfAccountsCode=#{chart_code}&positionBenefitTypeCode=#{labor_benefits_type_code}&laborBenefitRateCategoryCode=#{labor_benefits_rate_category_code}")
  end

  def get_random_asset_processor
    get_random_principal_name_for_role('KFS-SYS', 'Asset Processor')
  end

  def get_random_chart_administrator
    get_random_principal_name_for_role('KFS-SYS', 'Chart Administrator (cu)')
  end

  def get_random_chart_manager
    get_random_principal_name_for_role('KFS-SYS', 'Chart Manager')
  end

  def get_random_contracts_and_grants_manager
    get_random_principal_name_for_role('KFS-SYS', 'Contracts & Grants Manager')
  end

  def get_random_kfs_operations_user
    get_first_principal_name_for_role('KFS-SYS', 'Operations')
  end

  def get_random_kfs_user
    get_random_principal_name_for_role('KFS-SYS', 'User')
  end

  def get_random_kfs_user_not_being_contracts_and_grants_processor
    kfs_users = get_principal_names_for_role('KFS-SYS', 'User')
    cg_processors = get_principal_names_for_role('KFS-SYS', 'Contracts & Grants Processor')
    kfs_users_who_are_not_cg_processors = kfs_users - cg_processors
    kfs_users_who_are_not_cg_processors.sample
  end

  def get_random_labor_distribution_manager
    get_random_principal_name_for_role('KFS-LD', 'Labor Distribution Manager (cu)')
  end


  private

  # Intended to only be invoked internal to this module from methods get_aft_parameter_values_as_hash or
  # get_aft_parameter_value so a cache of KFS_AFTEST namespace parameters already looked up via the web service
  # will be used first and the web service will be called only when the requested parameter is not found in the cache.
  # @param [String] parameter_name Constant string indicating parameter being requested.
  # @return [Array] Array of strings representing the value associated with the parameter being requested.
  #                 This array could be a single item or could contain multiple items representing key-value pairs.
  #                 The calling routine (get_aft_parameter_values_as_hash OR get_aft_parameter_value) is responsible for
  #                 knowing how the parameter is constructed in the application.
  def perform_aft_parameter_retrieval(parameter_name)
    if $AFT_PARAMETER_CONSTANTS[parameter_name.to_sym].nil?
      $AFT_PARAMETER_CONSTANTS[parameter_name.to_sym] = get_parameter_values(ParameterConstants::AFT_PARAMETER_NAMESPACE, parameter_name)
      $AFT_PARAMETER_CONSTANTS[parameter_name.to_sym]
    else #AFT parameter already looked up, return what is cached
      $AFT_PARAMETER_CONSTANTS[parameter_name.to_sym]
    end
  end

  # Obtains application parameter values defined in KFS.
  # @param [String] namespace_code Namespace to use for parameter lookup
  # @param [String] parameter_name Parameter to lookup
  # @param [String] component_code Component code to use during parameter lookup
  # @param [String] application_id Application ID to use during parameter lookup
  # @return [Array] Array of strings representing the value for the requested parameter. Value could contain a single
  #                 string or multiple key=value pairs depending upon how the requested parameter is defined.
  def get_parameter_values(namespace_code, parameter_name, component_code='All', application_id='KFS')
    raise ArgumentError, 'namespace_code missing' if namespace_code.to_s == ''
    raise ArgumentError, 'parameter_name missing' if parameter_name.to_s == ''

    paramKey = ParameterKeyType.new()
    paramKey.setApplicationId(application_id)
    paramKey.setNamespaceCode(namespace_code)
    paramKey.setComponentCode(component_code)
    paramKey.setName(parameter_name)
    begin
      parameter_service.getParameterValuesAsString(paramKey).getValue().to_a
    rescue Java::JavaxXmlWs::WebServiceException
      # long running web service data request, timeout must have been hit
      raise StandardError.new("Java::JavaxXmlWs::WebServiceException caught long running web service data request for [get_parameter_values] namespace_code=#{namespace_code}= component_code=#{component_code}= parameter_name=#{parameter_name}=")
    end
  end

  #Calls the webservice to obtain a hash of multiple business objects having the requested attributes.
  def get_kuali_business_objects(namespace_code, object_type, identifiers)
    # Create new mechanize agent and hit the main page
    # then login once directed to CUWA
    page = ''
    Mechanize.start do |agent|
      begin
        page = agent.get($base_url)
      rescue OpenSSL::SSL::SSLError => sslError
        clock = Time.new
        puts "Rescued OpenSSL::SSL::SSLError #{sslError} at Current Time : #{clock.inspect} while attempting: agent.get($base_url) where base_url=#{$base_url}"
        raise
      rescue Mechanize::ResponseCodeError => responseError
        clock = Time.new
        puts "Rescued Mechanize::ResponseCodeError #{responseError} at Current Time : #{clock.inspect} while attempting: agent.get($base_url) where base_url=#{$base_url}"
        raise
      end

      #First we need to hit up the weblogin form and get our selves a cookie
      perform_university_login(page)

      #now lets backdoor
      agent.get($base_url + 'portal.do?selectedTab=main&backdoorId=' + get_first_principal_name_for_role('KFS-SYS', 'Technical Administrator'))

      #finally make the request to the data object page
      query = $base_url + 'dataobjects/' + namespace_code + '/' + object_type + '.xml?' + identifiers

      begin
        page = agent.get(query)
      rescue OpenSSL::SSL::SSLError => sslError
        clock = Time.new
        puts "Rescued OpenSSL::SSL::SSLError #{sslError} at Current Time : #{clock.inspect} while attempting: page = agent.get(query) where base_url=#{$base_url}"
        raise
      rescue Mechanize::ResponseCodeError => responseError
        clock = Time.new
        puts "Rescued Mechanize::ResponseCodeError #{responseError} at Current Time : #{clock.inspect} while attempting: page = agent.get(query) where base_url=#{$base_url}"
        raise
      end
    end

    #pares the XML into a hash
    XmlSimple.xml_in(page.body)
  end

  #Returns a single random business object with the requested attributes.
  def get_kuali_business_object(namespace_code, object_type, identifiers)
    business_objects = get_kuali_business_objects(namespace_code, object_type, identifiers)
    if business_objects.values[0].nil?
      raise RuntimeError, 'get_kuali_business_objects returned no objects'
    else if business_objects.keys[0].include?'businessobject'
           business_objects.values[0].sample
         else
           business_objects
         end
    end
  end

  def get_random_principal_name_for_role(name_space, role_name)
    @@prinicpal_names ||= Hash.new{|hash, key| hash[key] = Hash.new}
    @@prinicpal_names[name_space][role_name] = get_principal_name_for_principal_id(get_random_principal_id_for_role(name_space, role_name))
  end

  def get_random_principal_id_for_role(name_space, role_name)
    principalIds = role_service.getRoleMemberPrincipalIds(name_space, role_name, StringMapEntryListType.new).getPrincipalId()
    principalIds.get(rand(0..(principalIds.size() - 1)))
  end


  def get_principal_names_for_role(name_space, role_name)
    principal_names = Array.new
    role_service.getRoleMemberPrincipalIds(name_space, role_name, StringMapEntryListType.new).getPrincipalId().each {|id| principal_names.push(get_principal_name_for_principal_id(id))}
    principal_names
  end

  def get_first_principal_name_for_role(name_space, role_name)
    @@prinicpal_names ||= Hash.new{|hash, key| hash[key] = Hash.new}
    @@prinicpal_names[name_space][role_name] = get_principal_name_for_principal_id(get_first_principal_id_for_role(name_space, role_name))
  end

  def get_first_principal_id_for_role(name_space, role_name)
    role_service.getRoleMemberPrincipalIds(name_space, role_name, StringMapEntryListType.new).getPrincipalId().get(0)
  end

  def get_principal_name_for_principal_id(principal_name)
    identity_service.getEntityByPrincipalId(principal_name).getPrincipals().getPrincipal().get(0).getPrincipalName()
  end

end
