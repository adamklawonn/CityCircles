Feature: As an admin ISBAT manage suggestions

  Background: Set up user and log in
    Given there is a typus user with email "admin@test.com" and password "columbia"
    And I am logged in as typus user "admin@test.com" with password "columbia"
  
  @rack_test
  Scenario: Create comment
    Given I am on the admin dashboard
    And there is a user with the username "user" and password "password"
    And I follow "Comments"
    Then I should see "Comments"
    And I should see "There are no comments."
    And I follow "Add entry"
    When I fill in "item_title" with "My Comment"
    And I fill in "item_body" with "This is a body"
    And I select "user" from "item_author_id"
    When I press "Create entry"
    Then I should see "Comment successfully created."
    
  @rack_test
  Scenario: Edit comment
    Given there is a comment with title "My Comment" and body "This is a comment body"
    And I am on the admin dashboard
    And I follow "Comments"
    When I follow "Edit"
    Then the "item_title" field should contain "My Comment"
    And the "item_body" field should contain "This is a comment body"
    When I fill in "item_title" with "New Comment Title"
    And I fill in "item_body" with "This is a new comment body"
    When I press "Update entry"
    Then I should see "Comment successfully updated."
  
  @rack_test
  Scenario: Destroy comment
    Given there is a comment with title "My Comment" and body "Delete Me!"
    And I am on the admin dashboard
    And I follow "Comments"
    And I follow "Trash"
    Then I should not see "My Comment"
    And I should not see "Delete Me!"
    And I should see "Comment successfully removed."
    And I should see "There are no comments."
  
  @rack_test
  Scenario: Viewing Comments
    Given there is a comment with title "My Comment" and body "This is a comment body"
    And I am on the admin dashboard
    And I follow "Comments"
    Then I should see "My Comment"
  
  
  
  
    