Given /^there is a tweet "([^\"]*)"$/ do |body|
  Factory.create(:tweet, {:body => body})
end
