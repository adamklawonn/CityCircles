Feature: As an org isbat manage text ads

  Background: Setup Ben's Trikes Organization
    Given I have setup the homepage
    And there is a user with the username "test" and password "password"
    And there is an organization called "Ben's Trikes"
    And the user with username "test" is part of the "Ben's Trikes" organization
    And I am on the home page
    And I am logged in as "test" with password "password"
    Then I should see "organizations"
    When I follow "organizations"
    Then I should see "Your Organizations"
    And I should see "Ben's Trikes"
    When I follow "Ben's Trikes"

  @test_first
  Scenario: (Test First) Creating a pending Text Ad
    Then I should see "No pending campaigns"
    When I follow "Text Ad"
    Then I should see "New Text Ad Campaign" 
    And I fill in "text_ad_message" with "Come Join Us!"
    And I fill in "text_ad_link" with "http://www.google.com"
    And I select "19th Ave / Camelback" from "place"
    And I select "Group A" from "group"
    And I fill in "text_ad_starts_at_date" with "3/1/2010"
    And I fill in "text_ad_starts_at_time" with "1:00 AM"
    And I fill in "text_ad_ends_at_date" with "3/1/2011"
    And I fill in "text_ad_ends_at_time" with "1:00 AM"
    And I press "Submit for Approval"
    Then I should see "Text Ad"
    And I should not see "No pending campaigns"
  

  @test_first
  Scenario: Trying to create a text ad with more than 20 characters
    Then show me the page
    Then I should see "No pending campaigns"
    When I follow "Text Ad"
    Then I should see "New Text Ad Campaign" 
    And I fill in "text_ad_message" with "Come Join Us!1234567812312312"
    And I fill in "text_ad_link" with "http://www.google.com"
    And I select "19th Ave / Camelback" from "place"
    And I select "Group A" from "group"
    And I fill in "text_ad_starts_at_date" with "3/1/2010"
    And I fill in "text_ad_starts_at_time" with "1:00 AM"
    And I fill in "text_ad_ends_at_date" with "3/1/2011"
    And I fill in "text_ad_ends_at_time" with "1:00 AM"
    And I press "Submit for Approval"
    Then I should see "Message cannot be longer than 20 characters"
  
  @test_first
  Scenario: (Test First) Editing a pending Text Ad
    Then I should see "No pending campaigns"
    When I follow "Text Ad"
    Then I should see "New Text Ad Campaign" 
    And I fill in "text_ad_message" with "Come Join Us!"
    And I fill in "text_ad_link" with "http://www.google.com"
    And I select "19th Ave / Camelback" from "place"
    And I select "Group A" from "group"
    And I fill in "text_ad_starts_at_date" with "3/1/2010"
    And I fill in "text_ad_starts_at_time" with "1:00 AM"
    And I fill in "text_ad_ends_at_date" with "3/1/2011"
    And I fill in "text_ad_ends_at_time" with "1:00 AM"
    And I press "Submit for Approval"
    Then I should see "Text Ad"
    And I should not see "No pending campaigns"
    When I follow "Text Ad"
    Then I should see "Edit Text Ad Campaign"
    And the "text_ad_message" field should contain "Come Join Us!"
    And the "text_ad_link" field should contain "http://www.google.com"
    Then "place" should have "19th Ave / Camelback" selected
    Then "group" should have "Group A" selected
    And the "text_ad_starts_at_date" field should contain "3/1/2010"
    And the "text_ad_starts_at_time" field should contain "1:00 AM"
    And the "text_ad_ends_at_date" field should contain "3/1/2011"
    And the "text_ad_ends_at_time" field should contain "1:00 AM"
    And I fill in "text_ad_message" with "We already left!"
    And I press "Update Campaign"
    Then I should see "Text Ad"
    And I should not see "No pending campaigns"
    When I follow "Text Ad"
    Then I should see "Edit Text Ad Campaign"
    And the "text_ad_message" field should contain "We already left!"
    And the "text_ad_link" field should contain "http://www.google.com"
    Then "place" should have "19th Ave / Camelback" selected
    Then "group" should have "Group A" selected
    And the "text_ad_starts_at_date" field should contain "3/1/2010"
    And the "text_ad_starts_at_time" field should contain "1:00 AM"
    And the "text_ad_ends_at_date" field should contain "3/1/2011"
    And the "text_ad_ends_at_time" field should contain "1:00 AM"
  
  @test_first
  Scenario: (Test First) Deleting a pending Text Ad
    Then I should see "No pending campaigns"
    When I follow "Text Ad"
    Then I should see "New Text Ad Campaign" 
    And I fill in "text_ad_message" with "Come Join Us!"
    And I fill in "text_ad_link" with "http://www.google.com"
    And I select "19th Ave / Camelback" from "place"
    And I select "Group A" from "group"
    And I fill in "text_ad_starts_at_date" with "3/1/2010"
    And I fill in "text_ad_starts_at_time" with "1:00 AM"
    And I fill in "text_ad_ends_at_date" with "3/1/2011"
    And I fill in "text_ad_ends_at_time" with "1:00 AM"
    And I press "Submit for Approval"
    Then I should see "Text Ad"
    And I should not see "No pending campaigns"
    When I follow "Text Ad"
    Then I should see "Edit Text Ad Campaign"
    And I should see "Delete this campaign"
    And the "text_ad_message" field should contain "Come Join Us!"
    When I follow "Delete this campaign"
    Then I should see "Are you sure you want to delete this Text Ad Campaign"
    When I follow "Yes"
    Then I should see "Text Ad Campaign successfully deleted"
