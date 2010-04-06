Feature: Admin interests
  As an admin I should be able to add a new entry
  As an admin I should be able to edit a interest
  As an admin I should be able to delete an interest
  
  Background: Set up user and log in
    Given there is a typus user with email "admin@test.com" and password "columbia"
    Given I am logged in as typus user "admin@test.com" with password "columbia"
  
  Scenario: As an admin I should be able to add a new entry
    And I visit "/admin"
    And I follow "Interests"
    When I follow "Add entry"
    Then I should see "Interests › New"
    When I fill in "item_name" with "Ladies"
    And I press "Create entry"
    Then I should see "Interest successfully created."
    
  Scenario: As an admin I should be able to edit a interest
    Given there is an interest "Ladies"
    And I am on the edit page for interest "Ladies"
    Then I should see "Interests › Edit"
    When I fill in "item_name" with "Ladies"
    And I press "Update entry"
    Then I should see "Interest successfully updated."
  
  @javascript
  Scenario: As an admin I should be able to delete an interest
    Given there is an interest "Ladies"
    And I visit "/admin/interests"
    When I click "ok" in dialog
    When I follow "Remove"
    Then I should see "Interest successfully removed."