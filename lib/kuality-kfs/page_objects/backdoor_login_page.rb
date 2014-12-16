class BackdoorLoginPage < BasePage

  page_url "#{$base_url}backdoorlogin.do"

  element(:username) { |b| b.text_field(name: 'backdoorId')}
  button 'Login'

  def initialize_page
    username.when_present
  end

end