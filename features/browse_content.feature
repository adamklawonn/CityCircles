Feature: Browse content

  Scenario: Browse content as a guest
    Given there is a user with the email "test@testuser.com"
    Given there is a map called "Map 1" with "3" layers created by "test@testuser.com"
    Given there is a collection of map icons created by "test@testuser.com"
    Given there is a "Events" post type on "Layer Title 0" with a "news" icon
    Given there is a point of interest called "Interesting Point" on "Map 1" map at "Layer Title 0" layer with "news" icon created by "test@testuser.com"
    Given there is a post called "My Post" of type "Events" for point of interest "Interesting Point" created by "test@testuser.com"
    Given I am on the home page
    Then I should see "My Post shortname"
    When I follow "My Post shortname"
    And I should see "My Post"
