Feature: As an admin ISBAT manage events

  Background: Set up user and log in
    Given there is a typus user with email "admin@test.com" and password "columbia"
    And I am logged in as typus user "admin@test.com" with password "columbia"
    And there is a post "Halloween"
    And there is a post "Christmas"

  Scenario: Create event
    Given I am on the admin dashboard
    And I follow "Events"
    Then I should be on the admin events list page
    When I follow "Add entry"
    Then I should be on the admin new event page
    And I should see "Events › New"
    When I select "2010" from "item_starts_at_1i"
    And I select "October" from "item_starts_at_2i"
    And I select "31" from "item_starts_at_3i"
    And I select "05" from "item_starts_at_4i"
    And I select "00" from "item_starts_at_5i"
    And I select "PM" from "item_starts_at_7i"
    And I select "2010" from "item_ends_at_1i"
    And I select "October" from "item_ends_at_2i"
    And I select "31" from "item_ends_at_3i"
    And I select "11" from "item_ends_at_4i"
    And I select "59" from "item_ends_at_5i"
    And I select "PM" from "item_ends_at_7i"
    And I select "Halloween" from "item_post_id"
    And press "Create entry"
    Then I should be on the admin edit event page for the event
    And I should see "Event successfully created."
    And "item_starts_at_1i" should have "2010" selected
    And "item_starts_at_2i" should have "October" selected
    And "item_starts_at_3i" should have "31" selected
    And "item_starts_at_4i" should have "05" selected
    And "item_starts_at_5i" should have "00" selected
    And "item_starts_at_7i" should have "PM" selected
    And "item_ends_at_1i" should have "2010" selected
    And "item_ends_at_2i" should have "October" selected
    And "item_ends_at_3i" should have "31" selected
    And "item_ends_at_4i" should have "11" selected
    And "item_ends_at_5i" should have "59" selected
    And "item_ends_at_7i" should have "PM" selected
    And "item_post_id" should have "Halloween" selected
    When I follow "Back to list"
    Then I should see "Halloween"
  
  Scenario: Update event
    Given there is an event
    And I am on the admin dashboard
    And I follow "Events"
    And I follow "Edit"
    And I select "Christmas" from "item_post_id"
    When I press "Update entry"
    Then I should see "Event successfully updated."
    And "item_post_id" should have "Christmas" selected
    When I follow "Back to list"
    Then I should see "Christmas"
    
  @rack_test
  Scenario: Remove event
    Given there is an event
    And I am on the admin dashboard
    And I follow "Events"
    When I follow "Trash"
    Then I should be on the admin events list page
    And I should see "Event successfully removed."
    And I should see "There are no events."
