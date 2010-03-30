Given /^I have a point of interest "([^\"]*)"$/ do |label|
  interest_point = Factory.create(:interest_point, {:label => label})
end

When /^I click "([^\"]*)"$/ do |thingiclicked|
  find(thingiclicked).click
end
