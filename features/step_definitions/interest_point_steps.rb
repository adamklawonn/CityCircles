Given /^there is an interest point called "([^\"]*)"$/ do |interest_point_label|
  Factory.create(:interest_point, :label => interest_point_label)
end