Given /^there is a hobby "([^\"]*)"$/ do |hobby_name|
  Factory.create(:hobby, :name => hobby_name)
end