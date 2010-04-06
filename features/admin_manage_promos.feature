Feature: As an admin ISBAT manage promos

  Background: Set up user and log in
    Given there is a typus user with email "admin@test.com" and password "columbia"
    And I am logged in as typus user "admin@test.com" with password "columbia"
    And there is an organization called "Scary kids scaring kids"
    And there is a user with the username "boogieman" and password "secret"
    And "boogieman" is the leader of "Scary kids scaring kids"
    And there is a post "Halloween"
  
  @test_first
  Scenario: (Test First) Creating a promo
    Given I am on the admin dashboard
    And I follow "Promos"
    And I follow "Add entry"
    Then I should be on the admin new promo page
    And I should see "Promos › New"
    When I fill in "item_title" with "Boo!"
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
    And I select "Scary kids scaring kids" from "item_organization_id"
    And I select "boogieman" from "item_author_id"
    And I check "item_is_approved"
    And I select "Halloween" from "item_post_id"
    And I press "Create entry"
    Then I should be on the admin edit promo page for "Boo!"
    And I should see "Promo successfully created."
    And I should see "Promos › Edit"
    And the "item_title" field should contain "Boo!"
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
    And "item_organization_id" should have "Scary kids scaring kids" selected
    And "item_author_id" should have "boogieman" selected
    And "item_is_approved" should be checked
    And "item_post_id" should have "Halloween" selected
    When I visit the "Halloween" post
    Then I should see "Boo!"
  
  Scenario: Editing a promo
    Given there is a promo called "Boo!"
    And I am on the admin dashboard
    And I follow "Promos"
    And I follow "Edit"
    Then I should be on the admin edit promo page for "Boo!"
    And I should see "Promos › Edit"
    When I fill in "item_title" with "New boo title!"
    And I press "Update entry"
    Then I should be on the admin edit promo page for "New boo title!"
    And the "item_title" field should contain "New boo title!"
  
  @rack_test
  Scenario: Deleting a promo
    Given there is a promo called "Boo!"
    And I am on the admin dashboard
    And I follow "Promos"
    When I follow "Trash"
    Then I should see "Promo successfully removed."
    And I should not see "Boo!"