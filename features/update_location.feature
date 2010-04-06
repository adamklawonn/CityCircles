Feature: Member managing their locations

  Scenario: Adding locations
    Given there is a user with the username "test" and password "password"
    And I am logged in as "test" with password "password"
    And the following interest points:
      | label                 |
      | Montebello / 19th Ave |
      | 19th Ave / Camelback  |
      | 7th Ave / Camelback   |
    And I am on my settings page
    And I follow "Places"
    Then I should see "Place"
    When I select "Montebello / 19th Ave" from "user_location_interest_point_id"
    And I press "Add Location"
    Then I should see "Place added."
    And I should see "Montebello / 19th Ave" within "ul#location_list"
    
  Scenario: Removing locations
    Given there is a user with the username "test" and password "password"
    And I am logged in as "test" with password "password"
    And the following interest points:
      | label                 |
      | Montebello / 19th Ave |
      | 19th Ave / Camelback  |
      | 7th Ave / Camelback   |
    And I have the location "Montebello / 19th Ave"
    And I have the location "19th Ave / Camelback"
    And I am on my settings page
    And I follow "Places"
    Then I should see "Montebello / 19th Ave" within "ul#location_list"
    And I should see "19th Ave / Camelback" within "ul#location_list"
    When I follow "Remove"
    Then I should not see "Montebello / 19th Ave" within "ul#location_list"
    And I should see "19th Ave / Camelback" within "ul#location_list"