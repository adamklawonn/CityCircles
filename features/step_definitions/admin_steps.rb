Given /^there is an admin user with the username "([^\"]*)" and password "([^\"]*)"$/ do |login, password|
  u = Factory.create(:user, {:login => login, :password => password, :password_confirmation => password, :email => "#{login}@test.com", :roles => "admin"})
  ud = Factory.create(:user_detail, {:user_id => u.id})
end
