Feature: Authentication
  As a user
  I want to be able to be able to log in
  
  Scenario: Successfully Recover Password
    Given I am on the login page
    When  I follow "I Forgot My Password"
    Then  I should see "Reset Password"
    Given I am on the reset password page
    And   there is a user with the email "test@test.com"
    And   I fill in "email" with "test@test.com"
    And   I press "Reset Password"
    Then  "test@test.com" should receive an email
    When  I open the email
    And   I follow "Click here to reset your password"
    Then  I should see "Change My Password"
    And   I fill in "password" with "newpassword"
    And   I fill in "password_confirmation" with "newpassword"
    And   I press "Save New Password"
    Then  I should see "New password saved"

  Scenario: Unsuccessfully Recover Password because passwords don't match
    Given I am on the login page
    When  I follow "I Forgot My Password"
    Then  I should see "Reset Password"
    Given I am on the reset password page
    And   there is a user with the email "test@test.com"
    And   I fill in "email" with "test@test.com"
    And   I press "Reset Password"
    Then  "test@test.com" should receive an email
    When  I open the email
    And   I follow "Click here to reset your password"
    Then  I should see "Change My Password"
    And   I fill in "password" with "newpassword"
    And   I fill in "password_confirmation" with "not-newpassword"
    And   I press "Save New Password"
    Then  I should see "Passwords provided do not match"
    
  Scenario: Unuccessfully Recover Password because email address provided does not exist
    Given I am on the login page
    When  I follow "I Forgot My Password"
    Then  I should see "Reset Password"
    Given I am on the reset password page
    And   there is a user with the email "test@test.com"
    And   I fill in "email" with "test@tester.com"
    And   I press "Reset Password"
    Then  I should see "Sorry. We could not find a user with that email address."
