Feature: Submit a suggestion
  In order improve the amazing site called CityCircles
  As a guest
  I want to be able to submit a suggestion
  
  Scenario: Submit a suggestion and get some validation
    Given I am on the login page
    And I follow "contact"
    Then I should see "Got a question, suggestion or concern? We want to hear it."
    Given I am on the contact us page
    And I fill in "suggestion_email" with "test@test.com"
    And I fill in "suggestion_body" with "this is a suggestion"
    Then I press "suggestion_submit"
    Then I should see "Sign In"
    And I should see "Thank you!"