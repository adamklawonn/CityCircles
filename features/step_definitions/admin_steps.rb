Given /^there is an admin user with the username "([^\"]*)" and password "([^\"]*)"$/ do |login, password|
  u = Factory.create(:user, {:login => login, :password => password, :password_confirmation => password, :email => "#{login}@test.com", :roles => "admin"})
  ud = Factory.create(:user_detail, {:user_id => u.id})
end

Given /^there is a typus user with email "([^\"]*)" and password "([^\"]*)"$/ do |email, password|
  Factory.create(:typus_user, {:email => email, :password => password})
end

When /^I log in incorrectly 6 times$/ do
  6.times do
    When 'I fill in "user_email" with "test@dog.com"'
    And 'I fill in "user_password" with "pass"'
    And 'I press "Sign in"'
  end
end

Given /^I am logged in as typus user "([^\"]*)" with password "([^\"]*)"$/ do |email, password|
  visit "/admin/sign_in"
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  click_button 'Sign in'
end

Given /^there is an interest "([^\"]*)"$/ do |name|
  Factory.create(:interest, {:name => name})
end

Given /^there is an organization named "([^\"]*)"$/ do |name|
  Factory.create(:organization, {:name => name})
end
