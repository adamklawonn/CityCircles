Feature: As an admin ISBAT assign roles to users

  Background: Set up user and log in
    Given there is a typus user with email "admin@test.com" and password "columbia"
    And I am logged in as typus user "admin@test.com" with password "columbia"
    And there is a user with the username "newuser" and password "secret"
    And there is a role "member"
    And there is a role "org_leader"
  
  @test_first
  Scenario: (Test First) Add role to user
    Given I am on the admin dashboard
    And I follow "User roles"
    Then I should be on the admin user role list page
    When I follow "Add entry"
    Then I should be on the admin new user role page
    When I select "newuser" from "user_id"
    And I select "member" from "role_id"
    And I press "Create entry"
    Then I should be on the admin edit user role page for "newuser", "member"
    And I should see "User role successfully created."
    And "user_id" should have "newuser" selected
    And "role_id" should have "member" selected
    When I follow "Back to list"
    Then I should see "newuser"
    And I should see "member"
  
  @test_first
  Scenario: (Test First) Edit role for user
    Given "newuser" has the role "member"
    And I am on the admin dashboard
    And I follow "User roles"
    And I follow "Edit"
    And I select "org_leader" from "role_id"
    And I press "Update entry"
    Then I should see "User role successfully updated."
    And "role_id" should have "org_leader" selected
  
  @test_first
  Scenario: (Test First) Remove role from user
    Given "newuser" has the role "member"
    And "newuser" has the role "org_leader"
    And I am on the admin dashboard
    And I follow "User roles"
    And I follow "Trash"
    Then I should be on the admin user role list page
    And I should see "User role successfully remove."
    And I should not see "member"