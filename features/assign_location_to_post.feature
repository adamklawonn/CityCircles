Feature: Assigning a location to a post

  Scenario: Assigning a location by clicking on the map
    Given everything is setup to create posts
    Given I am on the new post page with a point of interest and post type "Events"
    When I fill in "post_headline" with "Oh Emm Gee - It's an EVENT!"
    And I fill in "post_short_headline" with "Yeah, I said it!"
    And I fill in "lat" with "31.5124"
    And I fill in "lng" with "-112.854"
    And I fill in "event_starts_at_date" with "3/1/2010"
    And I fill in "event_starts_at_time" with "1:00 AM"
    And I fill in "event_ends_at_date" with "3/1/2011"
    And I fill in "event_ends_at_time" with "1:00 AM"
    And I fill in "post_body" with "I like-a da news. It-a gives me da edge on wass-a happenin"
    Then I check "post_certification"
    When I press "Post"
    Then I should see "Post created."
    
  Scenario: Assigning and reassigning a location by clicking on the map
    Given everything is setup to create posts
    Given I am on the new post page with a point of interest and post type "Events"
    When I fill in "post_headline" with "Oh Emm Gee - It's an EVENT!"
    And I fill in "post_short_headline" with "Yeah, I said it!"
    And I fill in "lat" with "31.5124"
    And I fill in "lng" with "-112.854"
    And I fill in "lat" with "31.5224"
    And I fill in "lng" with "-112.754"
    And I fill in "event_starts_at_date" with "3/1/2010"
    And I fill in "event_starts_at_time" with "1:00 AM"
    And I fill in "event_ends_at_date" with "3/1/2011"
    And I fill in "event_ends_at_time" with "1:00 AM"
    And I fill in "post_body" with "I like-a da news. It-a gives me da edge on wass-a happenin"
    Then I check "post_certification"
    When I press "Post"
    Then I should see "Post created."
    
  @test_first
  Scenario: (Test First) Assigning a location by entering an address
    Given everything is setup to create posts
    Given I am on the new post page with a point of interest and post type "Events"
    When I fill in "post_headline" with "Oh Emm Gee - It's an EVENT!"
    And I fill in "post_short_headline" with "Yeah, I said it!"
    And I fill in "event_address" with "123 E Camelback, Phoenix"
    And I fill in "event_starts_at_date" with "3/1/2010"
    And I fill in "event_starts_at_time" with "1:00 AM"
    And I fill in "event_ends_at_date" with "3/1/2011"
    And I fill in "event_ends_at_time" with "1:00 AM"
    And I fill in "post_body" with "I like-a da news. It-a gives me da edge on wass-a happenin"
    Then I check "post_certification"
    When I press "Post"
    Then I should see "Post created."
  