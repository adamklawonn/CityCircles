Feature: As an admin ISBAT manage hobbies

  Background: Set up user and log in
    Given there is a typus user with email "admin@test.com" and password "columbia"
    And I am logged in as typus user "admin@test.com" with password "columbia"

  Scenario: Add hobby
    Given I am on the admin dashboard
    And I follow "Hobbies"
    Then I should be on the admin hobbies list page
    When I follow "Add entry"
    Then I should be on the admin hobbies new page
    And I should see "Hobbies › New"
    When I fill in "item_name" with "Professional Skeeball"
    And press "Create entry"
    Then I should be on the admin hobby edit page for "Professional Skeeball"
    And the "item_name" field should contain "Professional Skeeball"
    And I should see "Hobby successfully created."
    When I follow "Back to list"
    Then I should see "Professional Skeeball"
  
  Scenario: Update hobby
    Given there is a hobby "Professional Skeeball"
    And I am on the admin dashboard
    And I follow "Hobbies"
    When I follow "Edit"
    Then I should be on the admin hobby edit page for "Professional Skeeball"
    And the "item_name" field should contain "Professional Skeeball"
    When I fill in "item_name" with "Hog Tying"
    And press "Update entry"
    Then I should be on the admin hobby edit page for "Hog Tying"
    And I should see "Hobby successfully updated."
    And the "item_name" field should contain "Hog Tying"
    When I follow "Back to list"
    Then I should see "Hog Tying"
  
  @rack_test
  Scenario: Remove hobby
    Given there is a hobby "Professional Skeeball"
    And I am on the admin dashboard
    And I follow "Hobbies"
    When I follow "Trash"
    Then I should be on the admin hobbies list page
    And I should see "Hobby successfully removed."
    And I should not see "Professional Skeeball"
  