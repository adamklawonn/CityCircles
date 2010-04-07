Feature: As an admin ISBAT manage organizations

  Background: Set up user and log in
    Given there is a typus user with email "admin@test.com" and password "columbia"
    And I am logged in as typus user "admin@test.com" with password "columbia"

  Scenario: Add Organization
    Given there is an interest point called "Gangplank HQ"
    And there is a user with the username "pirate" and password "secret"
    Given I am on the admin dashboard
    Then show me the page
    And I follow "Organizations"
    Then I should be on the admin organizations list page
    When I follow "Add entry"
    Then I should be on the admin "organizations" "new" page
    And I should see "Organizations › New"
    When I fill in "item_name" with "Test Organization"
    And I fill in "item_lat" with "33.519894"
    And I fill in "item_lng" with "-112.099709"
    And I select "Gangplank HQ" from "item_interest_point_id"
    And I select "pirate" from "item_author_id"
    And press "Create entry"
    Then I should be on the admin organization edit page for "Test Organization"
    And the "item_name" field should contain "Test Organization"
    And I should see "Organization successfully created."
    When I follow "Back to list"
    Then I should see "Test Organization"
  
  Scenario: Update Organization
    Given there is an organization named "Test Organization"
    And I am on the admin dashboard
    And I follow "Organizations"
    When I follow "Edit"
    Then I should be on the admin organization edit page for "Test Organization"
    And the "item_name" field should contain "Test Organization"
    When I fill in "item_name" with "New Test Organization"
    And press "Update entry"
    Then I should be on the admin organization edit page for "New Test Organization"
    And I should see "Organization successfully updated."
    And the "item_name" field should contain "New Test Organization"
    When I follow "Back to list"
    Then I should see "New Test Organization"
  
  @rack_test
  Scenario: Remove Organization
    Given there is an organization named "Test Organization"
    And I am on the admin dashboard
    And I follow "Organizations"
    When I follow "Remove"
    Then I should be on the admin organizations list page
    And I should see "Organization successfully removed."
    And I should not see "Test Organization"

  @test_first
  Scenario: Activate an Organization
    Given there is an organization named "Test Organization"
    And I am on the admin dashboard
    And I follow "Organizations"
    When I follow "Edit"
    Then I should be on the admin organization edit page for "Test Organization"
    And the "item_name" field should contain "Test Organization"
    And I check "item_is_active"
    And press "Update entry"
    Then I should be on the admin organization edit page for "New Test Organization"
    And I should see "Organization successfully updated."
    And "item_is_active" should be checked
