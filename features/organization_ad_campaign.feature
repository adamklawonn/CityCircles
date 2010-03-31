Feature: Manage Organization Ads
  @test_first
  Scenario: Creating a pending Homepage Map Ad
    Given I have setup my homepage
    And there is a user with the username "test" and password "password"
    And there is an organization called "Ben's Trikes"
    And the user with username "test" is part of the "Ben's Trikes" organization
    And I am on the home page
    And  I follow "sign in"
    And  I fill in "user_session_login" with "test"
    And  I fill in "user_session_password" with "password"
    And  I press "Login"
    Then I should see "organizations"
    When I follow "organizations"
    Then I should see "Your Organizations"
    And I should see "Ben's Trikes"
    When I follow "Ben's Trikes"
    Then I should see "No pending campaigns"
    When I follow "Ad"
    Then I should see "New Ad Campaign" 
    When I select "Homepage Map - Size: height : 100px, width : 100px" from "ad_placement"
    And I attach the file "/Users/integrum/Projects/CityCircles/features/support/image.jpg" to "ad_graphic"
    And I fill in "ad_starts_at_date" with "3/1/2010"
    And I fill in "ad_starts_at_time" with "1:00 AM"
    And I fill in "ad_ends_at_date" with "3/1/2011"
    And I fill in "ad_ends_at_time" with "1:00 AM"
    And I press "Submit for Approval"
    Then I should see "Homepage Map Ad"
    And I should not see "No pending campaigns"
  
  @test_first
  Scenario: Editing a pending Homepage Map Ad
    Given I have a Home Map Ad
    When I click "Homepage Map Ad"
    And I should see "Edit Ad Campaign"
    Then "ad_placement" should have "Homepage Map - Size: height : 100px, width : 100px" selected
    When I select "Homepage Under Map - Size: height : 100px, width : 940px" from "ad_placement"
    And the "ad_starts_at_date" field should contain "3/1/2010"
    And the "ad_starts_at_time" field should contain "1:00 AM"
    And the "ad_ends_at_date" field should contain "3/1/2011"
    And the "ad_ends_at_time" field should contain "1:00 AM"
    Then there should be an image named "image.jpg"
    Then I press "Update Campaign"
    Then I should see "Homepage Under Map Ad"
    And I should not see "No pending campaigns"
    
  @test_first
  Scenario: Delete a pending Homepage Map Ad
    Given I have a Home Map Ad
    When I click "Homepage Map Ad"
    And I should see "Edit Ad Campaign"
    Then "ad_placement" should have "Homepage Map - Size: height : 100px, width : 100px" selected
    When I follow "Delete Campaign"
    Then I should see "Are you sure you want to delete this campaign?"
    When I follow "Yes"
    Then I should see "Pending Campaign successfully deleted"
    And I should see "No pending campaigns"

  @test_first
  Scenario: Creating a pending Text Ad
    Given I have setup my homepage
    And there is a user with the username "test" and password "password"
    And there is an organization called "Ben's Trikes"
    And the user with username "test" is part of the "Ben's Trikes" organization
    And I am on the home page
    And  I follow "sign in"
    And  I fill in "user_session_login" with "test"
    And  I fill in "user_session_password" with "password"
    And  I press "Login"
    Then I should see "organizations"
    When I follow "organizations"
    Then I should see "Your Organizations"
    And I should see "Ben's Trikes"
    When I follow "Ben's Trikes"
    Then I should see "No pending campaigns"
    When I follow "Text Ad"
    Then I should see "New Text Ad Campaign" 
    And I fill in "text_ad_message" with "Come Join Us!"
    And I fill in "text_ad_starts_at_date" with "3/1/2010"
    And I fill in "text_ad_starts_at_time" with "1:00 AM"
    And I fill in "text_ad_ends_at_date" with "3/1/2011"
    And I fill in "text_ad_ends_at_time" with "1:00 AM"
    And I press "Submit for Approval"
    Then I should see "Text Ad"
    And I should not see "No pending campaigns"
    
  @test_first
  Scenario: Editing a pending Text Ad
    Given I have setup my homepage
    And there is a user with the username "test" and password "password"
    And there is an organization called "Ben's Trikes"
    And the user with username "test" is part of the "Ben's Trikes" organization
    And I am on the home page
    And  I follow "sign in"
    And  I fill in "user_session_login" with "test"
    And  I fill in "user_session_password" with "password"
    And  I press "Login"
    Then I should see "organizations"
    When I follow "organizations"
    Then I should see "Your Organizations"
    And I should see "Ben's Trikes"
    When I follow "Ben's Trikes"
    Then I should see "No pending campaigns"
    When I follow "Text Ad"
    Then I should see "New Text Ad Campaign" 
    And I fill in "text_ad_message" with "Come Join Us!"
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
    And the "text_ad_starts_at_date" field should contain "3/1/2010"
    And the "text_ad_starts_at_time" field should contain "1:00 AM"
    And the "text_ad_ends_at_date" field should contain "3/1/2011"
    And the "text_ad_ends_at_time" field should contain "1:00 AM"
    
  @test_first
  Scenario:Deleting a pending Text Ad
    Given I have setup my homepage
    And there is a user with the username "test" and password "password"
    And there is an organization called "Ben's Trikes"
    And the user with username "test" is part of the "Ben's Trikes" organization
    And I am on the home page
    And  I follow "sign in"
    And  I fill in "user_session_login" with "test"
    And  I fill in "user_session_password" with "password"
    And  I press "Login"
    Then I should see "organizations"
    When I follow "organizations"
    Then I should see "Your Organizations"
    And I should see "Ben's Trikes"
    When I follow "Ben's Trikes"
    Then I should see "No pending campaigns"
    When I follow "Text Ad"
    Then I should see "New Text Ad Campaign" 
    And I fill in "text_ad_message" with "Come Join Us!"
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