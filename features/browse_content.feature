Feature: Browse content
@wip
  Scenario: As a guest ISBAT view a post
    Given there is an author
    And there is a map
    And there is a map icon
    And there is an events map layer
    And there is an interest point
    And there is an event post type
    And there is a post of type event
    # Given I have a map with the following attributes:
    # | shortname | title    | description | lat       | lng         | zoom | author_id |
    # | lightrail | Stations | blah        | 33.474644 | -111.986650 | 11   | 0         |
    # Given I have a post with the following attributes:
    # | headline     | short_headline | body                  | lat     | interest_point_id | map_layer_id | author_id |
    # | Test Heading | TH             | Some sample body test | 21.2344 | 0                 | 0            | 0         |
    Given I am on the home page
    Then show me the page
    Then I should see "Test Heading"
    When I follow "New Event Post Title"
    Then I should be on the event show page
    And I should see "New Event Post Details"
    
  # Scenario: As a logged in user ISBAT view a post
