Feature: Create post
  In order add content to the site
  As a user
  I want to add posts to the site

  @javascript
  Scenario: Create a post
    Given I have setup my homepage
    Given there is a user with the username "test" and password "password"
    Given there is a map called "Zen Garden" with a layer called "events" created by "test@test.com"
    Given I have a point of interest "My POI"
    Given I am on the home page
    Then  I follow "sign in"
    Then  I fill in "user_session_login" with "test"
    Then  I fill in "user_session_password" with "password"
    Then  I press "Login"
    Given I am on the new post page with a point of interest and post type "Events"
    When  I fill in "post_headline" with "New Post"
    And   I fill in "post_short_headline" with "New Post Short Headline"
    And   I fill in "lat" with "31.5124"
    And   I fill in "lng" with "-112.854"
    And I fill in "event_starts_at_date" with "3/1/2010"
    And I fill in "event_starts_at_time" with "1:00 AM"
    And I fill in "event_ends_at_date" with "3/1/2011"
    And I fill in "event_ends_at_time" with "1:00 AM"
    And I fill in "post_body" with "This is a body"
    And   I check "post_certification"
    When  I press "Post"
    Then I should see "Post created."