Feature: Authentication
  As a user
  I want to be able to be able to log in
  
  Scenario: Recover Password
    Given I am on the login page
    When I follow "I Forgot My Password"
    Then I should see "Reset Password"
  
  
  

  
