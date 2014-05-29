And /^I (#{BasePage::available_buttons}) the document$/ do |button|
  button.gsub!(' ', '_')
  on(KFSBasePage).send(button)
  on(YesOrNoPage).yes if button == 'cancel'
end