Feature: As an admin ISBAT manage ads

  Background: Set up user and log in
    Given there is a typus user with email "admin@test.com" and password "columbia"
    And I am logged in as typus user "admin@test.com" with password "columbia"

  Scenario: Creating an ad
    Given there is an organization called "Fuzzy Bunnies"
    And I am on the admin dashboard
    And I follow "Ads"
    Then I should be on the admin ads page
    When I follow "Add entry"
    Then I should be on the admin new ad page
    When I select "Fuzzy Bunnies" from "item_organization_id"
    And I select "Homepage Map height : 100px, width : 100px" from "item_placement"
    And I select the file "features/support/image.jpg" to upload for "item_graphic"
    And I fill in "item_link_uri" with "http://www.citycircles.com"
    And I select "2010" from "item_starts_at_1i"
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
    And I press "Create entry"
    Then I should be on the admin ad edit page for the ad with link uri "http://www.citycircles.com"
    And I should see "Ad successfully created."
    And "item_organization_id" should have "Fuzzy Bunnies" selected
    And "item_placement" should have "Homepage Map height : 100px, width : 100px" selected
    And I should see "image.jpg"
    And the "item_link_uri" field should contain "http://www.citycircles.com"
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
    When I follow "Back to list"
    Then I should see "Fuzzy Bunnies"
  
  Scenario: Updating an ad
    Given there is an ad with link uri "http://www.citycircles.com"
    And I am on the admin dashboard
    And I follow "Ads"
    And I follow "Edit"
    And I fill in "item_link_uri" with "http://www.google.com"
    And I press "Update entry"
    Then I should see "Ad successfully updated."
    And the "item_link_uri" field should contain "http://www.google.com"
    
  
  @rack_test
  Scenario: Removing an ad
    Given there is an ad with link uri "http://www.citycircles.com"
    And I am on the admin dashboard
    And I follow "Ads"
    And I follow "Trash"
    Then I should be on the admin ads page
    And I should see "Ad successfully removed."
    And I should see "There are no ads."