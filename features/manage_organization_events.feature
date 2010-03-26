Feature: Manage organization events
  In order manage events
  As an organizer
  I want to manage events
  
  @wip
  Scenario: creating an event
    Given there is a user with the email "test@test.com"
    And   I have an interest point
    And   I have an organization with name "Test Organization" with author "test@test.com"
    When  I visit the the new organization page
    And   I fill in name with ""
  
  
  

  
