Feature: As an admin ISBAT manage users

  Background: Set up user and log in
    Given there is a typus user with email "admin@test.com" and password "columbia"
    And I am logged in as typus user "admin@test.com" with password "columbia"

  @test_first
  Scenario: (Test First) Deactivating a user
    Given there is an active user with the username "fred"
    And I am on the admin dashboard
    And I follow "Manage Users"
    Then I should be on the admin manage users page
    And I should see "fred"
    When I follow "fred"
    Then I should be on the admin edit user page for "fred"
    And "active" should be checked
    When I uncheck "active"
    And press "Update entry"
    Then I should see "fred has been successfully deactivated"
    
  @test_first
  Scenario: (Test First) Activating a user
    Given there is an inactive user with the username "fred"
    And I am on the admin dashboard
    And I follow "Manage Users"
    Then I should be on the admin manage users page
    And I should see "fred"
    When I follow "fred"
    Then I should be on the admin edit user page for "fred"
    And "active" should be unchecked
    When I check "active"
    And press "Update entry"
    Then I should see "fred has been successfully activated"