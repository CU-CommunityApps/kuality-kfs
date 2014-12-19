class BackdoorLoginPage < BasePage

  page_url "#{$base_url}backdoorlogin.do"

  element(:username) { |b| b.frm.text_field(name: 'backdoorId')}
  value(:login_info_readonly) { |b| b.div(id: 'login-info').text.strip }

  button 'Login'

end