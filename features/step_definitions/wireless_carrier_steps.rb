Given /^there is a wireless carrier named "([^\"]*)" with a gateway of "([^\"]*)"$/ do |name, email_gateway|
  Factory.create(:wireless_carrier, :name => name, :email_gateway => email_gateway)
end