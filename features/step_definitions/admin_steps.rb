Given /^there is an admin user with the username "([^\"]*)" and password "([^\"]*)"$/ do |login, password|
  u = Factory.create(:user, {:login => login, :password => password, :password_confirmation => password, :email => "#{login}@test.com", :roles => "admin"})
  ud = Factory.create(:user_detail, {:user_id => u.id})
end

Given /^there is a typus user$/ do
  Factory.create(:typus_user, {:email => 'admin@test.com'})
end

When /^I log in incorrectly 6 times$/ do
  6.times do
    When 'I fill in "user_email" with "test@dog.com"'
    And 'I fill in "user_password" with "pass"'
    And 'I press "Sign in"'
  end
end
