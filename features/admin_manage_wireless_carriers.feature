Feature: As an admin ISBAT manage wireless carriers

  Background: Set up user and log in
    Given there is a typus user with email "admin@test.com" and password "columbia"
    And I am logged in as typus user "admin@test.com" with password "columbia"

  @test_first
  Scenario: (Test First) Add wireless carrier
    Given I am on the admin dashboard
    And I follow "Wireless carriers"
    Then I should be on the admin wireless carriers list page
    When I follow "Add entry"
    And I fill in "item_name" with "AT&T" 
    And I fill in "item_email_gateway" with "att.net"
    And I press "Create entry"
    Then I should be on the admin wireless carriers list page
    And I should see "Wireless carrier successfully created."
  
  @test_first
  Scenario: (Test First) Update wireless carrier
    Given there is a wireless carrier named "AT&T" with a gateway of "att.net"
    And I am on the admin dashboard
    And I follow "Wireless carriers"
    And I follow "Edit"
    Then I should be on the wireless carrier edit page for "AT&T"
    And the "item_name" field should contain "AT&T"
    And the "item_email_gateway" field should contain "att.net"
    And I fill in "item_name" with "verizon" 
    And I fill in "item_email_gateway" with "verizon.net"
    And I press "Update entry"
    Then I should be on the admin wireless carriers list page
    And I should see "Wireless carrier successfully updated."
    And I should see "verizon"
    And I should see "verizon.net"
  
  @rack_test
  Scenario: Delete wireless carrier
    Given there is a wireless carrier named "AT&T" with a gateway of "att.net"
    And I am on the admin dashboard
    And I follow "Wireless carriers"
    And I follow "Trash"
    Then I should see "Wireless carrier successfully removed."
    And I should not see "AT&T"
    