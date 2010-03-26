When /^I search for "([^\"]*)"$/ do |query|
  %x[rake RAILS_ENV=cucumber xapian:update_index]
  fill_in "q", :with => query
  click_button 'go'
end
