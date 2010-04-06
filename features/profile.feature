Feature: Profile
  As a user I should be able to edit my profile
  As a guest I should not be able to visit the settings page
  
  Scenario: As a user I should be able to edit my profile
    Given there is a user with the username "test" and password "password"
    And I am logged in as "test" with password "password"
    Given I am on my settings page
    Then I fill in "user_details_first_name" with "Caige"
    And I press "Save"
    Then I should see "Account settings updated."
    
  Scenario: As a guest I should not be able to visit the settings page (not logged in)
    Given I am on my settings page
    Then I should see "You must be logged in to do that!"
  
  
  