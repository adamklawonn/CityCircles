Given /^everything is setup to create posts$/ do
  Given 'I have setup the homepage'
  Given 'there is a user with the username "test" and password "password"'
  Given 'there is a map called "Zen Garden" with a layer called "events" created by "test@test.com"'
  Given 'I have a point of interest "My POI"'
  Given 'I am on the home page'
  Then  'I follow "sign in"'
  Then  'I fill in "user_session_login" with "test"'
  Then  'I fill in "user_session_password" with "password"'
  Then  'I press "Login"'
end

Given /^I have a point of interest "([^\"]*)"$/ do |label|
  interest_point = Factory.create(:interest_point, {:label => label})
end

When /^I click "([^\"]*)"$/ do |thingiclicked|
  find_by_id(thingiclicked).click
end

Given /^there is a post "([^\"]*)"$/ do |post_headline|
  Factory.create(:post, :headline => post_headline, :short_headline => post_headline)
end

When /^I visit the "([^\"]*)" post$/ do |post_headline|
  visit events_post_path(Post.find_by_headline(post_headline))
end