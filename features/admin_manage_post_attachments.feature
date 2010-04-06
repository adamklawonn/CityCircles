Feature: As an admin ISBAT manage post attachments

  Background: Set up user and log in
    Given there is a typus user with email "admin@test.com" and password "columbia"
    And I am logged in as typus user "admin@test.com" with password "columbia"

  @test_first
  Scenario: (Test First) Attempting to add a 5th attachment
    Given there is a post called "Attachment Post" with "4" attachments
    And I am on the admin dashboard
    And I follow "Posts"
    And I follow "Edit"
    And I follow "Post attachments"
    And I follow "Add entry"
    Then I should see "Post attachments › New"
    When I fill in "item_caption" with "this is my caption"
    And I select the file "features/support/image.jpg" to upload for "item_attachment"
    And I select "Attachment Post" from "item_post_id"
    And I press "Create entry"
    Then I should see "you can not add anymore attachments without removing one first"
  
  @rack_test
  Scenario: Removing an attachment
    Given there is a post called "Attachment Post" with "1" attachments
    And I am on the admin dashboard
    And I follow "Posts"
    And I follow "Edit"
    And I follow "Post attachments"
    And I follow "Trash"
    Then I should see "Post attachment successfully removed."
    And I should not see "attachment caption"
    
    
  Scenario: Adding an attachment
    Given there is a post called "Attachment Post" with "3" attachments
    And I am on the admin dashboard
    And I follow "Posts"
    And I follow "Edit"
    And I follow "Post attachments"
    And I follow "Add entry"
    Then I should see "Post attachments › New"
    When I fill in "item_caption" with "this is my caption"
    And I select the file "features/support/image.jpg" to upload for "item_attachment"
    And I select "Attachment Post" from "item_post_id"
    And I press "Create entry"
    Then I should see "Post attachment successfully created."

    