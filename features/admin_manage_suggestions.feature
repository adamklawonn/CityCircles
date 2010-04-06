Feature: As an admin ISBAT manage suggestions

  Background: Set up user and log in
    Given there is a typus user with email "admin@test.com" and password "columbia"
    And I am logged in as typus user "admin@test.com" with password "columbia"

  Scenario: View suggestion
    Given there is a suggestion of "Test your site!" from "mad@user.com"
    And I am on the admin dashboard
    And I follow "Suggestions"
    Then I should see "Test your site!"
    And I should see "mad@user.com"
    And I follow "Edit"
    Then the "item_email" field should contain "mad@user.com"
    And the "item_body" field should contain "Test your site!"
  
  @rack_test
  Scenario: Delete suggestion
    Given there is a suggestion of "Test your site!" from "mad@user.com"
    And I am on the admin dashboard
    And I follow "Suggestions"
    When I follow "Trash"
    Then I should see "Suggestion successfully removed."
    And I should not see "Test your site!"
    And I should not see "mad@user.com"
    And I should see "There are no suggestions."