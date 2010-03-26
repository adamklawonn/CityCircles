When /^I search for "([^\"]*)"$/ do |query|
  %x[rake RAILS_ENV=cucumber xapian:update_index]
  fill_in "q", :with => query
  click_button 'go'
end

Then /^there should be "([^\"]*)" in the search history$/ do |text|
  assert SearchHistory.find_by_body(text).count > 0
end
