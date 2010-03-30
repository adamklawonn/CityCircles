Feature: Manage organization events
  In order manage events
  As an organizer
  I want to manage events

  @wip
  Scenario: creating an event
    Given I have setup my homepage
    Given there is a user with the username "test" and password "password"
    And   I am logged in as "test" with password "password"
    Then  show me the page
    And   I have an interest point
    And   I have an organization with name "Test Organization" with author "test@test.com"
    Given I am on the new event page
    And   I fill in name with ""