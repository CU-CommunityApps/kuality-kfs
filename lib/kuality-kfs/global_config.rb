module GlobalConfig
  require 'mechanize'
  require 'xmlsimple'

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

  def get_parameter_values(namespace_code, parameter_name, component_code='All')
    raise ArgumentError, 'namespace_code missing' if namespace_code.to_s == ''
    raise ArgumentError, 'parameter_name missing' if parameter_name.to_s == ''

    paramKey = ParameterKeyType.new()
    paramKey.setApplicationId('KFS')
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
  # Intended to only be invoked internal to this module from methods get_aft_parameter_values,
  # get_aft_parameter_values_as_hash, or get_aft_parameter_value so that a cache of KFS_AFTEST namespace parameters
  # already looked up via the web service will be used first and the web service will be called only when the requested
  # parameter is not found in the cache.
  def perform_aft_parameter_retrieval(parameter_name)
    if $AFT_PARAMETER_CONSTANTS[parameter_name.to_sym].nil?
      $AFT_PARAMETER_CONSTANTS[parameter_name.to_sym] = get_parameter_values(ParameterConstants::AFT_PARAMETER_NAMESPACE, parameter_name)
      $AFT_PARAMETER_CONSTANTS[parameter_name.to_sym]
    else #AFT parameter already looked up, return what is cached
      $AFT_PARAMETER_CONSTANTS[parameter_name.to_sym]
    end
  end
  # # The next three methods are used to obtain any of the AFT-specific parameters.
  # # They should be used with a defined parameter constant, not passing in a string.
  # # i.e. get_aft_parameter_values_as_hash(ParameterConstants::DEFAULTS_FOR_ACCOUNT)
  # def get_aft_parameter_values(parameter_name)
  #   perform_aft_parameter_retrieval(parameter_name)
  # end
  # same as above but returns a hash which is easier to work with
  def get_aft_parameter_values_as_hash(parameter_name)
    h = {}
    perform_aft_parameter_retrieval(parameter_name).each do |key_val_pair|
      k,v = key_val_pair.split('=')
      h[k.to_sym] = v
    end
    h
  end
  # Same as the first one but used when you know there is only a single value in the parameter
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
  def get_first_principal_id_for_role(name_space, role_name)
    role_service.getRoleMemberPrincipalIds(name_space, role_name, StringMapEntryListType.new).getPrincipalId().get(0)
  end
  def get_random_principal_id_for_role(name_space, role_name)
    principalIds = role_service.getRoleMemberPrincipalIds(name_space, role_name, StringMapEntryListType.new).getPrincipalId()
    principalIds.get(rand(0..(principalIds.size() - 1)))
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
  def get_principal_name_for_principal_id(principal_name)
    identity_service.getEntityByPrincipalId(principal_name).getPrincipals().getPrincipal().get(0).getPrincipalName()
  end
  def get_first_principal_name_for_role(name_space, role_name)
    @@prinicpal_names ||= Hash.new{|hash, key| hash[key] = Hash.new}
    @@prinicpal_names[name_space][role_name] = get_principal_name_for_principal_id(get_first_principal_id_for_role(name_space, role_name))
  end
  def get_random_principal_name_for_role(name_space, role_name)
    @@prinicpal_names ||= Hash.new{|hash, key| hash[key] = Hash.new}
    @@prinicpal_names[name_space][role_name] = get_principal_name_for_principal_id(get_random_principal_id_for_role(name_space, role_name))
  end
  def get_principal_name_for_role(name_space, role_name)
    principal_names = Array.new
    role_service.getRoleMemberPrincipalIds(name_space, role_name, StringMapEntryListType.new).getPrincipalId().each {|id| principal_names.push(get_principal_name_for_principal_id(id))}
    principal_names
  end
  def get_document_initiator(document_type)
    permission_details = {'documentTypeName' => document_type}
    assignees = get_permission_assignees_by_template('KR-SYS', 'Initiate Document', permission_details).to_a
    if assignees.any?
      principal_id = assignees.delete_if{ |assignee| assignee.principalId == '2'}.sample.principalId
      person = identity_service.getEntity(principal_id)
      person.principals.principal.to_a.sample.principalName
    else
      get_principal_name_for_role('KFS-SYS', 'Manager').sample
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

  def get_generic_address_1()
    "#{rand(1..9999)} Evergreen Terrace"
  end
  def get_generic_city()
    random_letters(10)
  end
  def get_random_state_code()
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
  def fetch_random_capital_asset_object_code
    get_kuali_business_object('KFS-COA', 'ObjectCode', "universityFiscalYear=#{get_aft_parameter_value(ParameterConstants::CURRENT_FISCAL_YEAR)}&financialObjectSubTypeCode=CM&financialObjectTypeCode=EE&chartOfAccountsCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}")['financialObjectCode'][0]
  end
  def fetch_random_capital_asset_number
    # TODO : it took long time for asset search, so put several criteria to speed up the lookup
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

  def get_current_user
    unless @logged_in_users_list.nil? || @logged_in_users_list.empty?
      return @logged_in_users_list.last
    else
      return nil
    end
  end

  def set_current_user (user)
    unless @logged_in_users_list.nil?
      @logged_in_users_list.push user
    else
      @logged_in_users_list = Array.new
      @logged_in_users_list.push user
    end
  end

  def perform_backdoor_login(user)
    # do not continue, required parameter not sent
    fail ArgumentError, 'Required parameter "user" was not specified for perform_backdoor_login.' if user.nil?
    #ensure lowercase for user id as we will be attempting to find it as the Impersonating User
    user_lowercase = user.downcase

    visit (MainPage)
    on BackdoorLoginPage do |backdoorPage|
      backdoorPage.username.fit user_lowercase
      backdoorPage.login

      #Verify that the requested login actually happened and fail when it doesn't
      (backdoorPage.impersonating_user.include? user_lowercase).should be true

      set_current_user(user_lowercase)
    end
  end

  def get_restricted_vendor_number
    get_kuali_business_object('KFS-VND','VendorDetail',"activeIndicator=Y&vendorRestrictedIndicator=Y&vendorParentIndicator=Y&vendorDunsNumber=NULL")['vendorNumber'].sample
  end



    def global_config
      @@global_config ||= YAML.load_file("#{File.dirname(__FILE__)}/../../features/support/config.yml")[:basic]
    end

    def perform_university_login(page)
      @@global_config ||= YAML.load_file("#{File.dirname(__FILE__)}/../../features/support/config.yml")[:basic]
      cuwaform = page.form('login')
      page = page.form_with(:name => 'login') do |form|
        form.netid = @@global_config[:cuweblogin_user]
        form.password = @@global_config[:cuweblogin_password]
      end.submit
      page.form('bigpost').submit
    end

end
