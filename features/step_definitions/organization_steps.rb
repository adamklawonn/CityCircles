Given /^there is an organization called "([^\"]*)"$/ do |name|
  Factory.create(:organization, {:name => name})
end

Given /^the user with username "([^\"]*)" is part of the "([^\"]*)" organization$/ do |login, org_name|
  u = User.find_by_login(login)
  u.organization_members << OrganizationMember.new(:organization_id => Organization.find_by_name(org_name).id, :is_active => true)
  u.save!
end

Given /^I have a Home Map Ad/ do
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
end

Given /^There is an organization member$/ do
  Given 'I have setup the homepage'
  And 'there is a user with the username "test" and password "password"'
  And 'there is an organization called "Bens Trikes"'
  And 'the user with username "test" is part of the "Bens Trikes" organization'
  And 'I am on the home page'
  And  'I follow "sign in"'
  And  'I fill in "user_session_login" with "test"'
  And  'I fill in "user_session_password" with "password"'
  And  'I press "Login"'
  Then 'I should see "my profile"'
  When 'I follow "my profile"'
  Then 'I should see "edit profile"'
  And 'I should see "Add Members to my Organization"'
  When 'I follow "Add Members to my Organization"'
  Then 'I should see "Add New Member"'
  And 'I fill in "user_first_name" with "Mike"'
  And 'I fill in "user_last_name" with "Benner"'
  And 'I fill in "user_email" with "mike.benner@integrumtech.com"'
  And 'I fill in "user_cell_phone" with "555-1212"'
  And 'I press "Done!"'
  Then 'I should see "Thank you! Your new members will receive a welcome email shortly."'
  And 'I should be on the "test" profile page'
end

When /^(?:|I )select the file "([^\"]*)" to upload for "([^\"]*)"(?: within "([^\"]*)")?$/ do |path, field, selector|
  with_scope(selector) do
    attach_file(field, "#{RAILS_ROOT}/#{path}")
  end
end

Then /^"([^\"]*)" should have "([^\"]*)" selected$/ do |field, value|
  page.find(:xpath, "//select[@id='"+field+"']/option[@selected='selected']").node.text.should == value
end

Then /^there should be an image named "([^\"]*)"$/ do |value|
  page.source.match(value).should_not == nil
end

Then /^I fill in the hidden field "([^\"]*)" with "([^\"]*)"$/ do |field, value|
  page.find(:xpath, "//input[@id='"+field+"']").set(value)
end