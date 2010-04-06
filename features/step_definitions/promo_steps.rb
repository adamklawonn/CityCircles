Given /^there is a promo called "([^\"]*)"$/ do |promo_name|
  p = Factory.create(:promo, :title => promo_name)
end