Given /^there is a user with the email "([^\"]*)" and password "([^\"]*)"$/ do |email, password|
  u = Factory.create(:user, {:email => email, :password => password, :password_confirmation => password})
  ud = Factory.create(:user_detail, {:user_id => u.id})
end

Given /^I am logged in as "([^\"]*)" with password "([^\"]*)"$/ do |username, password|
  visit signin_url
  fill_in "user_session_login", :with => username
  fill_in "user_session_password", :with => password
  click_button "Login"
end

Given /^that I am on the profile page for "([^\"]*)"$/ do |email|
  polymorphic_path(User.find_by_email(email))
end
