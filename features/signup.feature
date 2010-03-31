Feature: Signup
  In order use this amazing site
  As a guest
  I want to signup
  @test_first
  Scenario: (Test First) Recieve a welcome email on signup
    # setup homepage for redirect after submit
    Given there is a user with the email "steve.swedler@integrumtech.com"
    Given there is a map called "Map 1" with "3" layers created by "steve.swedler@integrumtech.com"
    Given there is a collection of map icons created by "steve.swedler@integrumtech.com"
    Given there is a "Events" post type on "Layer Title 0" with a "news" icon
    Given there is a point of interest called "Interesting Point" on "Map 1" map at "Layer Title 0" layer with "news" icon created by "steve.swedler@integrumtech.com"
    Given there is a post called "My Post" of type "Events" for point of interest "Interesting Point" created by "steve.swedler@integrumtech.com"
    # Actual test code
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