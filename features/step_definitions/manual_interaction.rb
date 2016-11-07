And /^I send the ([A-Za-z0-9+ ]*) key to the ([A-Za-z0-9+ ]*) button$/ do |key, button|
  case button
    when 'Attach File'
      @browser.frm.input(id: 'attachmentFile').send_keys key.split('+').map{ |k| snake_case k }
    else
      @browser.frm.input(title: button).send_keys key.split('+').map{ |k| snake_case k }
  end
end

And /^I press the ([A-Za-z0-9+ ]*) key (\d+) times$/ do |key, times|
  times.to_i.times{ step "I press the #{key} key" }
end

When /^I click the (.*) button$/ do |button|
  case button
    when 'Attach File'
      @browser.frm.input(id: 'attachmentFile').click
    else
      @browser.frm.input(title: button).click
  end
end
