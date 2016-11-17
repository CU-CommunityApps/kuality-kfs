Before do
  @config = YAML.load_file("#{File.dirname(__FILE__)}/config.yml")[:basic]
  visit CUWebLoginPage do |page|
    if page.page_header_element.exists?
      page.netid.set @config[:cuweblogin_user]
      page.password.set @config[:cuweblogin_password]
      page.login
    end
  end
end
