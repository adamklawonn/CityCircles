Feature: Manage Organization Ads
  @test_first
  Scenario: (Test First) Creating a pending Homepage Map Ad
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
    And I select the file "features/support/image.jpg" to upload for "ad_graphic"
    And I fill in "ad_starts_at_date" with "3/1/2010"
    And I fill in "ad_starts_at_time" with "1:00 AM"
    And I fill in "ad_ends_at_date" with "3/1/2011"
    And I fill in "ad_ends_at_time" with "1:00 AM"
    And I press "Submit for Approval"
    Then I should see "Homepage Map Ad"
    And I should not see "No pending campaigns"
  
  @test_first
  Scenario: (Test First) Editing a pending Homepage Map Ad
    Given I have a Home Map Ad
    And I am on the home page
    And I follow "organizations"
    And I follow "Bens Trikes"
    And I follow "Homepage Map Ad"
    Then I should see "Edit Ad Campaign"
    And "ad_placement" should have "Homepage Map - Size: height : 100px, width : 100px" selected
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
  Scenario: (Test First) Delete a pending Homepage Map Ad
    Given I have a Home Map Ad
    And I am on the home page
    And I follow "organizations"
    And I follow "Bens Trikes"
    When I follow "Homepage Map Ad"
    And I should see "Edit Ad Campaign"
    Then "ad_placement" should have "Homepage Map - Size: height : 100px, width : 100px" selected
    When I follow "Delete Campaign"
    Then I should see "Are you sure you want to delete this campaign?"
    When I follow "Yes"
    Then I should see "Pending Campaign successfully deleted"
    And I should see "No pending campaigns"
    
  @test_first
  Scenario: (Test First) Creating a pending Profile Map Ad
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
    When I select "Profile Map - Size: height : 100px, width : 100px" from "ad_placement"
    And I select the file "features/support/image.jpg" to upload for "ad_graphic"
    And I fill in "ad_starts_at_date" with "3/1/2010"
    And I fill in "ad_starts_at_time" with "1:00 AM"
    And I fill in "ad_ends_at_date" with "3/1/2011"
    And I fill in "ad_ends_at_time" with "1:00 AM"
    And I press "Submit for Approval"
    Then I should see "Profile Map Ad"
    And I should not see "No pending campaigns"

  @test_first
  Scenario: (Test First) Editing a pending Profile Map Ad
    Given I have a Home Map Ad
    And I am on the home page
    And I follow "organizations"
    And I follow "Bens Trikes"
    And I follow "Profile Map Ad"
    Then I should see "Edit Ad Campaign"
    And "ad_placement" should have "Profile Map - Size: height : 100px, width : 100px" selected
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
  Scenario: (Test First) Delete a pending Profile Map Ad
    Given I have a Home Map Ad
    And I am on the home page
    And I follow "organizations"
    And I follow "Bens Trikes"
    When I follow "Profile Map Ad"
    And I should see "Edit Ad Campaign"
    Then "ad_placement" should have "Profile Map - Size: height : 100px, width : 100px" selected
    When I follow "Delete Campaign"
    Then I should see "Are you sure you want to delete this campaign?"
    When I follow "Yes"
    Then I should see "Pending Campaign successfully deleted"
    And I should see "No pending campaigns"

    
  @test_first
  Scenario: (Test First) Creating a pending Homepage Under Map Ad
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
    When I select "Homepage Under Map - Size: height : 100px, width : 940px" from "ad_placement"
    And I select the file "features/support/image.jpg" to upload for "ad_graphic"
    And I fill in "ad_starts_at_date" with "3/1/2010"
    And I fill in "ad_starts_at_time" with "1:00 AM"
    And I fill in "ad_ends_at_date" with "3/1/2011"
    And I fill in "ad_ends_at_time" with "1:00 AM"
    And I press "Submit for Approval"
    Then I should see "Homepage Map Ad"
    And I should not see "No pending campaigns"
  
  @test_first
  Scenario: (Test First) Editing a pending Homepage Under Map Ad
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
    When I select "Homepage Under Map - Size: height : 100px, width : 940px" from "ad_placement"
    And I select the file "features/support/image.jpg" to upload for "ad_graphic"
    And I fill in "ad_starts_at_date" with "3/1/2010"
    And I fill in "ad_starts_at_time" with "1:00 AM"
    And I fill in "ad_ends_at_date" with "3/1/2011"
    And I fill in "ad_ends_at_time" with "1:00 AM"
    And I press "Submit for Approval"
    And I am on the home page
    And I follow "organizations"
    And I follow "Bens Trikes"
    And I follow "Homepage Map Ad"
    Then I should see "Edit Ad Campaign"
    And "ad_placement" should have "Homepage Under Map - Size: height : 100px, width : 940px" selected
    When I select "Homepage Map - Size: height : 100px, width : 100px" from "ad_placement"
    And the "ad_starts_at_date" field should contain "3/1/2010"
    And the "ad_starts_at_time" field should contain "1:00 AM"
    And the "ad_ends_at_date" field should contain "3/1/2011"
    And the "ad_ends_at_time" field should contain "1:00 AM"
    Then there should be an image named "image.jpg"
    Then I press "Update Campaign"
    Then I should see "Homepage Map Ad"
    And I should not see "No pending campaigns"
    
  @test_first
  Scenario: (Test First) Delete a pending Homepage Under Map Ad
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
    When I select "Homepage Under Map - Size: height : 100px, width : 940px" from "ad_placement"
    And I select the file "features/support/image.jpg" to upload for "ad_graphic"
    And I fill in "ad_starts_at_date" with "3/1/2010"
    And I fill in "ad_starts_at_time" with "1:00 AM"
    And I fill in "ad_ends_at_date" with "3/1/2011"
    And I fill in "ad_ends_at_time" with "1:00 AM"
    And I press "Submit for Approval"
    And I am on the home page
    And I follow "organizations"
    And I follow "Bens Trikes"
    When I follow "Homepage Map Ad"
    And I should see "Edit Ad Campaign"
    Then "ad_placement" should have "Homepage Under Map - Size: height : 100px, width : 940px" selected
    When I follow "Delete Campaign"
    Then I should see "Are you sure you want to delete this campaign?"
    When I follow "Yes"
    Then I should see "Pending Campaign successfully deleted"
    And I should see "No pending campaigns"
    
  @test_first
  Scenario: (Test First) Creating a Promo
    Given I have setup my homepage
    And there is a user with the username "test" and password "password"
    And there is an organization called "Ben's Trikes"
    And the user with username "test" is part of the "Ben's Trikes" organization
    And I have a point of interest "19th Ave / Camelback"
    And there is a map called "map" with a layer called "promos" created by "test@test.com"
    And there is a collection of map icons created by "test@test.com"
    And there is a "promos" post type on "promos" with a "promos" icon
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
    When I follow "Promo"
    Then I should see "New Promo Campaign" 
    And I fill in "promo_title" with "This is our promo"
    And I fill in "promo_starts_at_date" with "3/1/2010"
    And I fill in "promo_starts_at_time" with "1:00 AM"
    And I fill in "promo_ends_at_date" with "3/1/2011"
    And I fill in "promo_ends_at_time" with "1:00 AM"
    And I select "19th Ave / Camelback" from "place"
    And I fill in "post_headline" with "This is a headline"
    And I fill in "post_short_headline" with "Short Headline"
    And I fill in "post_body" with "This is my promo body"
    And I check "post_certification"
    And I press "Submit for Approval"
    Then I should see "Promo"
    And I should not see "No pending campaigns"

  @test_first
  Scenario: (Test First) Editing a pending Promo
    Given I have setup my homepage
    And there is a user with the username "test" and password "password"
    And there is an organization called "Ben's Trikes"
    And the user with username "test" is part of the "Ben's Trikes" organization
    And I have a point of interest "19th Ave / Camelback"
    And there is a map called "map" with a layer called "promos" created by "test@test.com"
    And there is a collection of map icons created by "test@test.com"
    And there is a "promos" post type on "promos" with a "promos" icon
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
    When I follow "Promo"
    Then I should see "New Promo Campaign" 
    And I fill in "promo_title" with "This is our promo"
    And I fill in "promo_starts_at_date" with "3/1/2010"
    And I fill in "promo_starts_at_time" with "1:00 AM"
    And I fill in "promo_ends_at_date" with "3/1/2011"
    And I fill in "promo_ends_at_time" with "1:00 AM"
    And I select "19th Ave / Camelback" from "place"
    And I fill in "post_headline" with "This is a headline"
    And I fill in "post_short_headline" with "Short Headline"
    And I fill in "post_body" with "This is my promo body"
    And I check "post_certification"
    And I press "Submit for Approval"
    Then I should see "Promo"
    And I should not see "No pending campaigns"
    When I follow "Promo"
    Then I should see "Edit Promo Campaign"
    And the "promo_title" field should contain "This is our promo"
    And the "promo_starts_at_date" field should contain "3/1/2010"
    And the "promo_starts_at_time" field should contain "1:00 AM"
    And the "promo_ends_at_date" field should contain "3/1/2011"
    And the "promo_ends_at_time" field should contain "1:00 AM"
    Then "place" should have "19th Ave / Camelback" selected
    And the "post_headline" field should contain "This is a headline"
    And the "post_short_headline" field should contain "Short Headline"
    And the "post_body" field should contain "This is my promo body"
    And I fill in "promo_title" with "We have a new title for this promo"
    And I press "Update Promo"
    Then I should see "Promo"
    And I should not see "No pending campaigns"
    When I follow "Promo"
    Then I should see "Edit Promo Campaign"
    And the "promo_title" field should contain "We have a new title for this promo"
    And the "promo_starts_at_date" field should contain "3/1/2010"
    And the "promo_starts_at_time" field should contain "1:00 AM"
    And the "promo_ends_at_date" field should contain "3/1/2011"
    And the "promo_ends_at_time" field should contain "1:00 AM"
    Then "place" should have "19th Ave / Camelback" selected
    And the "post_headline" field should contain "This is a headline"
    And the "post_short_headline" field should contain "Short Headline"
    And the "post_body" field should contain "This is my promo body"

  @test_first
  Scenario: (Test First) Deleting a pending Promo
    Given I have setup my homepage
    And there is a user with the username "test" and password "password"
    And there is an organization called "Ben's Trikes"
    And the user with username "test" is part of the "Ben's Trikes" organization
    And I have a point of interest "19th Ave / Camelback"
    And there is a map called "map" with a layer called "promos" created by "test@test.com"
    And there is a collection of map icons created by "test@test.com"
    And there is a "promos" post type on "promos" with a "promos" icon
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
    When I follow "Promo"
    Then I should see "New Promo Campaign" 
    And I fill in "promo_title" with "This is our promo"
    And I fill in "promo_starts_at_date" with "3/1/2010"
    And I fill in "promo_starts_at_time" with "1:00 AM"
    And I fill in "promo_ends_at_date" with "3/1/2011"
    And I fill in "promo_ends_at_time" with "1:00 AM"
    And I select "19th Ave / Camelback" from "place"
    And I fill in "post_headline" with "This is a headline"
    And I fill in "post_short_headline" with "Short Headline"
    And I fill in "post_body" with "This is my promo body"
    And I check "post_certification"
    And I press "Submit for Approval"
    Then I should see "Promo"
    And I should not see "No pending campaigns"
    When I follow "Promo"
    Then I should see "Edit Promo Campaign"
    And the "promo_title" field should contain "This is our promo"
    And the "promo_starts_at_date" field should contain "3/1/2010"
    And the "promo_starts_at_time" field should contain "1:00 AM"
    And the "promo_ends_at_date" field should contain "3/1/2011"
    And the "promo_ends_at_time" field should contain "1:00 AM"
    Then "place" should have "19th Ave / Camelback" selected
    And the "post_headline" field should contain "This is a headline"
    And the "post_short_headline" field should contain "Short Headline"
    And the "post_body" field should contain "This is my promo body"
    And I should see "Delete this promo"
    When I follow "Delete this promo"
    Then I should see "Are you sure you want to delete this Promo Campaign"
    When I follow "Yes"
    Then I should see "Promo Campaign successfully deleted"
    
  @test_first
  Scenario: (Test First) Paying for an Ad
    Given I have a Home Map Ad
    And I am on the home page
    And I follow "organizations"
    And I follow "Bens Trikes"
    And I should see "Homepage Map Ad"
    When I follow "Pay for this campaign"
    Then I should see "Pay for Homepage Map Ad"
    When I fill in "billing_first_name" with "bob"
    And I fill in "billing_last_name" with "bobberson"
    And I fill in "billing_address" with "123 W 1st"
    And I fill in "billing_city" with "Phoenix"
    And I fill in "billing_state" with "AZ"
    And I fill in "billing_zip" with "85225"
    And I select "VISA" from "billing_card_type"
    And I fill in "billing_credit_card_number" with "1234123412341234"
    And I select "March" from "billing_credit_card_month"
    And I select "2020" from "billing_credit_card_year"
    And I fill in "billing_ccv" with "123"
    And I press "Pay"
    Then I should see "Thank you for your purchase!"
    