Before do
  @config = YAML.load_file("#{File.dirname(__FILE__)}/config.yml")[:basic]
  visit WebLoginPage do |page|
    #General Login
      page.netid.set @config[:weblogin_user]
      page.password.set @config[:weblogin_password]
      page.login
  end
end
