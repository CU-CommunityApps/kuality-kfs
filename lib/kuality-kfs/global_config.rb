module GlobalConfig
  def ksb_client
    @@ksb_client ||= KSBServiceClient.new()
  end
  def role_service
    @@role_service ||= ksb_client.getRoleService()
  end
  def identity_service
    @@identity_service ||= ksb_client.getIdentityService()
  end
  def parameter_service
    @@parameter_service ||= ksb_client.getParameterService()
  end
  def parameter_service
    @@parameter_service ||= ksb_client.getParameterService()
  end
  def get_parameter_values(namespace_code, parameter_name)
    paramKey = ParameterKeyType.new()
    paramKey.setApplicationId('KFS')
    paramKey.setNamespaceCode(namespace_code)
    paramKey.setComponentCode('All')
    paramKey.setName(parameter_name)
    @@parameter_values = parameter_service.getParameterValuesAsString(paramKey).getValue().to_a
  end
  def get_aft_parameter_values(parameter_name)
    get_parameter_values('KFS-AFTEST', parameter_name)
  end
  def get_aft_parameter_value(parameter_name)
    get_parameter_values('KFS-AFTEST', parameter_name)[0]
  end
  def get_first_principal_id_for_role(name_space, role_name)
    role_service.getRoleMemberPrincipalIds(name_space, role_name, StringMapEntryListType.new).getPrincipalId().get(0)
  end
  #def get_random_principal_id_for_role(name_space, role_name)
  #  principal_ids ||= role_service.getRoleMemberPrincipalIds(name_space, role_name, StringMapEntryListType.new)
  #  principal_ids.sample
  #end
  def get_principal_name_for_principal_id(principal_name)
    identity_service.getEntityByPrincipalId(principal_name).getPrincipals().getPrincipal().get(0).getPrincipalName()
  end
  def get_first_principal_name_for_role(name_space, role_name)
    @@prinicpal_names ||= Hash.new{|hash, key| hash[key] = Hash.new}

    if !@@prinicpal_names[name_space][role_name].nil?
      @@prinicpal_names[name_space][role_name]
    else
      @@prinicpal_names[name_space][role_name] = get_principal_name_for_principal_id(get_first_principal_id_for_role(name_space, role_name))
    end
  end
  #def get_random_principal_name_for_role(name_space, role_name)
  #  @@prinicpal_names ||= Hash.new{|hash, key| hash[key] = Hash.new}
  #
  #  if !@@prinicpal_names[name_space][role_name].nil?
  #    @@prinicpal_names[name_space][role_name]
  #  else
  #    @@prinicpal_names[name_space][role_name] = get_principal_name_for_principal_id(get_random_principal_id_for_role(name_space, role_name))
  #  end
  #end
end

World(GlobalConfig)