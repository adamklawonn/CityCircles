Feature: Wireless profile
  As a user
  I want to be able to manage my wireless devices

  @test_first
  Scenario: Adding a new wireless device to my profile
    Given I have setup my homepage
    Given there is a user with the username "test" and password "password"
    And I am logged in as "test" with password "password"
    Given I am on the "test" profile page
    Then I should see "Add New Device"
    When I follow "Add New Device"
    Then I should see "Add New Device"
    And I fill in "device_phone_number" with "555-1212"
    And I select "AT&T" from "device_carrier"
    And I press "Add Device"
    Then I should see "Your device has been successfully added!"
    And I should be on the "test" profile page

  @test_first
  Scenario: Editing an existing wireless device on my profile (with all data)
    Given I have setup my homepage
    Given there is a user with the username "test" and password "password"
    And I am logged in as "test" with password "password"
    Given that I have a wireless device with "AT&T" and the number "555-1212"
    Given I am on the "test" profile page
    Then I should see "Edit My Device"
    When I follow "Edit My Device"
    Then I should see "Edit My Device"
    And the "device_phone_number" should contain "555-1212"
    Then "device_carrier" should have "AT&T" selected
    And I fill in "device_phone_number" with "555-2424"
    And I select "Verizon" from "device_carrier"
    And I press "Update"
    Then I should see "Your device has been successfully updated!"
    And I should be on the "test" profile page

  @test_first
  Scenario: Editing an existing wireless device on my profile (with missing data)
    Given I have setup my homepage
    Given there is a user with the username "test" and password "password"
    And I am logged in as "test" with password "password"
    Given that I have a wireless device with "AT&T" and the number "555-1212"
    Given I am on the "test" profile page
    Then I should see "Edit My Device"
    When I follow "Edit My Device"
    Then I should see "Edit My Device"
    And the "device_phone_number" should contain "555-1212"
    Then "device_carrier" should have "AT&T" selected
    And I fill in "device_phone_number" with ""
    And I select "Verizon" from "device_carrier"
    And I press "Update"
    Then I should see "Oops! You're missing some information. Please complete the required fields."
    
  @test_first
  Scenario: Delete an existing wireless device on my profile
    Given I have setup my homepage
    Given there is a user with the username "test" and password "password"
    And I am logged in as "test" with password "password"
    Given that I have a wireless device with "AT&T" and the number "555-1212"
    Given I am on the "test" profile page
    Then I should see "Edit My Device"
    When I follow "Edit My Device"
    Then I should see "Edit My Device"
    And I should see "Delete this device"
    When I follow "Delete this device"
    Then I should see "Are you sure you want to delete your device?"
    When I follow "Yes"
    Then I should see "Your device has been successfully deleted!"
    And I should be on the "test" profile page
    And I should see "Add New Device"