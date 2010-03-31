Given /^that I have a wireless device with "([^\"]*)" and the number "([^\"]*)"$/ do |carrier, number|
  Given 'I am on the "test" profile page'
  Then 'I should see "Add New Device"'
  When 'I follow "Add New Device"'
  Then 'I should see "Add New Device"'
  And 'I fill in "device_phone_number" with "'+number+'"'
  And 'I select "AT&T" from "'+carrier+'"'
  And 'I press "Add Device"'
  Then 'I should see "Your device has been successfully added!"'
end