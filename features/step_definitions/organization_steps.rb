Given /^there is an organization called "([^\"]*)"$/ do |name|
  Factory.create(:organization, {:name => name})
end

Given /^the user with username "([^\"]*)" is part of the "([^\"]*)" organization$/ do |login, org_name|
  u = User.find_by_login(login)
  u.organization_members << OrganizationMember.new(:organization_id => Organization.find_by_name(org_name).id, :is_active => true)
  u.save!
end

Given /^I have a Home Map Ad/ do
  Given 'I have setup my homepage'
  And 'there is a user with the username "test" and password "password"'
  And 'there is an organization called "Bens Trikes"'
  And 'the user with username "test" is part of the "Bens Trikes" organization'
  And 'I am on the home page'
  And  'I follow "sign in"'
  And  'I fill in "user_session_login" with "test"'
  And  'I fill in "user_session_password" with "password"'
  And  'I press "Login"'
  Then 'I should see "organizations"'
  When 'I follow "organizations"'
  Then 'I should see "Your Organizations"'
  And 'I should see "Bens Trikes"'
  When 'I follow "Bens Trikes"'
  Then 'I should see "No pending campaigns"'
  When 'I follow "Ad"'
  Then 'I should see "New Ad Campaign"'
  When 'I select "Homepage Map - Size: height : 100px, width : 100px" from "ad_placement"'
  And 'I attach the file "/Users/integrum/Projects/CityCircles/features/support/image.jpg" to "ad_graphic"'
  And 'I fill in "ad_starts_at_date" with "3/1/2010"'
  And 'I fill in "ad_starts_at_time" with "1:00 AM"'
  And 'I fill in "ad_ends_at_date" with "3/1/2011"'
  And 'I fill in "ad_ends_at_time" with "1:00 AM"'
  And 'I press "Submit for Approval"'
  Then 'I should see "Homepage Map Ad"'
  And 'I should not see "No pending campaigns"'
end

Then /^"([^\"]*)" should have "([^\"]*)" selected$/ do |field, value|
  page.find(:xpath, "//select[@id='"+field+"']/option[@selected='selected']").node.text.should == value
end

Then /^there should be an image named "([^\"]*)"$/ do |value|
  page.source.match(value)
end