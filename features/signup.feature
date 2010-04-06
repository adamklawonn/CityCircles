Feature: Signup
  In order use this amazing site
  As a guest
  I want to signup
  @test_first
  Scenario: (Test First) Receive a welcome email on signup
    Given I have setup the homepage
    Given a clear email queue
    Given I am on the signup page
    When  I fill in "user_login" with "testuser"
    And   I fill in "user_password" with "123123"
    And   I fill in "user_password_confirmation" with "123123"
    And   I fill in "user_email" with "testuser@test.com"
    And   I fill in "user_details_first_name" with "Test"
    And   I fill in "user_details_last_name" with "User"
    And   I check "user_agreed_with_terms"
    And   I press "user_submit"
    Then  "testuser@test.com" should receive an email
    When  I open the email
    Then  I should see "thanks for registering"
    When  I follow "this link"
    Then  I should be on the profile page
    And   I should see "Account verified!"
    And   I should see "Test"
    And   I should see "User"
    Then  "testuser@test.com" should receive an email
    When  I open the email
    And   I should see "Thank you for joining other light rail passengers and nearby residents to make the city around the rail a success with CityCircles." in the email body
    
    