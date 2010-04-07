Feature: As an admin ISBAT manage organizations

  Background: Set up user and log in
    Given there is a typus user with email "admin@test.com" and password "columbia"
    And I am logged in as typus user "admin@test.com" with password "columbia"
    And there is an interest point called "Gangplank HQ"
    And there is a map icon name "mpicon"
    And there is a map layer named "mplayer"
    And there is a user with the username "pirate" and password "secret"

  @test_first 
  Scenario: Add Organization
    Given I am on the admin dashboard
    And I follow "Post types"
    Then I should be on the admin post type list page
    When I follow "Add entry"
    Then I should be on the admin post type new page
    And I should see "Post types › New"
    When I fill in "item_name" with "Awesome Post Type"
    And I fill in "item_shortname" with "awesome"
    And I fill in "item_twitter_hashtag" with "#awesm"
    And I select "mpicon" from "item_map_icon_id" #the select for map icon is not showing the name of the map icon just MapIcon#1
    And I select "mplayer" from "item_map_layer_id"
    And press "Create entry"
    Then I should be on the admin post type edit page for "Awesome Post Type"
    And the "item_name" field should contain "Awesome Post Type"
    And I should see "Post type successfully created."
    When I follow "Back to list"
    Then I should see "Awesome Post Type"
  
  Scenario: Update Post Type
    Given there is a post type named "Awesome Post Type"
    Given I am on the admin dashboard
    And I follow "Post types"
    Then I should be on the admin post type list page
    When I follow "Edit"
    Then I should be on the admin post type edit page for "Awesome Post Type"
    And the "item_name" field should contain "Awesome Post Type"
    When I fill in "item_name" with "More Awesome Post Type"
    And press "Update entry"
    Then I should be on the admin post type edit page for "More Awesome Post Type"
    And I should see "Post type successfully updated."
    And the "item_name" field should contain "More Awesome Post Type"
    When I follow "Back to list"
    Then I should see "More Awesome Post Type"
  
  @rack_test
  Scenario: Remove Post Type
    Given there is a post type named "Awesome Post Type"
    And I am on the admin dashboard
    And I follow "Post types"
    When I follow "Remove"
    Then I should be on the admin post type list page
    And I should see "Post type successfully removed."
    And I should not see "Awesome Post Type"
