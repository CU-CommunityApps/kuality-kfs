class BackdoorLoginPage < BasePage

  page_url "#{$base_url}backdoorlogin.do"

  element(:username) { |b| b.frm.text_field(name: 'backdoorId')}

  element(:login_info) { |b| b.div(id: 'login-info') }
  value(:logged_in_user) { |b| ((b.login_info.strongs)[0]).text.strip }
  value(:impersonating_user) { |b| (b.login_info.strongs)[1].text.strip }

  button 'Login'

end