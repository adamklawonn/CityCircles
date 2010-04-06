Given /^there is a user with the username "([^\"]*)" and password "([^\"]*)"$/ do |login, password|
  u = Factory.create(:user, {:login => login, :password => password, :password_confirmation => password, :email => "#{login}@test.com"})
  ud = Factory.create(:user_detail, {:user_id => u.id})
end

Given /^that I am on the profile page for "([^\"]*)"$/ do |login|
  polymorphic_path(User.find_by_login(login))
end
