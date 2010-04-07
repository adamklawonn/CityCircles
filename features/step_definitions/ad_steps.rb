Given /^there is an ad with link uri "([^\"]*)"$/ do |link_uri|
  Factory.create(:ad, :link_uri => link_uri)
end