Feature: Admin login
  As an admin I should be able to login to admin area
  As a regular user I should not be able to login to admin area
  
  Background: Set up an admin user on typus
    Given there is an admin user with the username "admin" and password "secret"
    And I am logged in as "admin" with password "secret"
    Given I have setup the homepage
    And I am on the homepage
    When I follow "admin"
    Then I should see "Enter your email below to create the first user."
    When I fill in "user_email" with "admin@test.com"
    And I press "Sign up"
    Then I should see "Welcome to the City Circles admin area."

  Scenario: As an admin I should be able to login to admin area
    Given no previously logged in user
    And I am logged in as "admin" with password "secret"
    And I am on the homepage
    When I follow "admin"
    And I fill in "user_email" with "admin@test.com"
    And I fill in "user_password" with "columbia"
    And I press "Sign in"
    Then I should see "Welcome to the City Circles admin area."
    
  Scenario: As a regular user I should not be able to login to admin area
    Given no previously logged in user
    Given there is a user with the username "user" and password "secret"
    And I am logged in as "user" with password "secret"
    And I am on the homepage
    Then I should not see "admin"