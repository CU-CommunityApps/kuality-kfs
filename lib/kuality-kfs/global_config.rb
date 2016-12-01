module GlobalConfig
  require 'mechanize'
  require 'xmlsimple'

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
