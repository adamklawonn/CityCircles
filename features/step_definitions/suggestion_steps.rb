Given /^there is a suggestion of "([^\"]*)" from "([^\"]*)"$/ do |body, email|
  Factory.create(:suggestion, :email => email, :body => body)
end