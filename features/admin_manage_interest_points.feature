Feature: As an admin ISBAT manage interest Points

  Background: Set up user and log in
    Given there is a typus user with email "admin@test.com" and password "columbia"
    And I am logged in as typus user "admin@test.com" with password "columbia"

  Scenario: Add Interest Point
    Given there is a map icon name "icon 1"
    And there is a user with the username "pirate" and password "secret"
    And there is a map layer named "fun spots"
    And there is a map called "phx"
    And I am on the admin dashboard
    When I follow "Interest points"
    Then I should be on the admin interest point list page
    When I follow "Add entry"
    Then I should be on the admin interest point new page
    When I fill in "item_label" with "Gangplank HQ"
    And I fill in "item_body" with "Integrum in the hizouse!"
    And I fill in "item_description" with "this is where its at"
    And I fill in "item_twitter_hashtag" with "gangplank"
    And I fill in "item_lat" with "37.0625"
    And I fill in "item_lng" with "-95.677068"
    And I select "MapIcon#1" from "item_map_icon_id"
    And I select "pirate" from "item_author_id"
    And I select "fun spots" from "item_map_layer_id"
    And I select "Map#2" from "item_map_id"
    And I press "Create entry"
    Then I should be on the admin interest point edit page for "Gangplank HQ"
    And I should see "Interest point successfully created."
    And the "item_label" field should contain "Gangplank HQ"
    And the "item_body" field should contain "Integrum in the hizouse!"
    And the "item_description" field should contain "this is where its at"
    And the "item_twitter_hashtag" field should contain "gangplank"
    And the "item_lat" field should contain "37.0625"
    And the "item_lng" field should contain "-95.677068"
    And "item_map_icon_id" should have "MapIcon#1" selected
    And "item_author_id" should have "pirate" selected
    And "item_map_layer_id" should have "fun spots" selected
    And "item_map_id" should have "Map#2" selected
    When I follow "Back to list"
    Then I should see "Gangplank HQ"
  
  Scenario: Update Interest Point
    Given there is an interest point called "Gangplank HQ"
    And I am on the admin dashboard
    And I follow "Interest points"
    And I follow "Edit"
    Then I should be on the admin interest point edit page for "Gangplank HQ"
    When I fill in "item_label" with "The Integrum Offices"
    And I press "Update entry"
    Then I should be on the admin interest point edit page for "The Integrum Offices"
    And I should see "Interest point successfully updated."
    And the "item_label" field should contain "The Integrum Offices"
    When I follow "Back to list"
    Then I should see "The Integrum Offices"
  
  @rack_test
  Scenario: Remove Interest Point
    Given there is an interest point called "Gangplank HQ"
    And I am on the admin dashboard
    And I follow "Interest points"
    And I follow "Trash"
    Then I should be on the admin interest point list page
    And I should see "Interest point successfully removed."
    And I should not see "Gangplank HQ"