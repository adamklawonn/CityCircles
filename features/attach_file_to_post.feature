Feature: Attaching files to post

  Scenario: Attaching one image to an event post
    Given everything is setup to create posts
    Given I am on the new post page with a point of interest and post type "Events"
    When I fill in "post_headline" with "Oh Emm Gee - It's an EVENT!"
    And I fill in "post_short_headline" with "Yeah, I said it!"
    And I fill in "lat" with "31.5124"
    And I fill in "lng" with "-112.854"
    And I fill in "event_starts_at_date" with "3/1/2010"
    And I fill in "event_starts_at_time" with "1:00 AM"
    And I fill in "event_ends_at_date" with "3/1/2011"
    And I fill in "event_ends_at_time" with "1:00 AM"
    And I fill in "post_body" with "I like-a da news. It-a gives me da edge on wass-a happenin"
    When I follow "Add Attachment"
    Then there should be an image named "/images/minus.png"
    And I select the file "features/support/image.jpg" to upload for "post_attachment_files[1]"
    Then I check "post_certification"
    When I press "Post"
    Then I should see "Post created."
    
  @test_first
  Scenario: Attempting to add 5 images to a post
    Given everything is setup to create posts
    Given I am on the new post page with a point of interest and post type "Events"
    When I fill in "post_headline" with "Oh Emm Gee - It's an EVENT!"
    And I fill in "post_short_headline" with "Yeah, I said it!"
    And I fill in "lat" with "31.5124"
    And I fill in "lng" with "-112.854"
    And I fill in "event_starts_at_date" with "3/1/2010"
    And I fill in "event_starts_at_time" with "1:00 AM"
    And I fill in "event_ends_at_date" with "3/1/2011"
    And I fill in "event_ends_at_time" with "1:00 AM"
    And I fill in "post_body" with "I like-a da news. It-a gives me da edge on wass-a happenin"
    When I follow "Add Attachment"
    And I select the file "features/support/image.jpg" to upload for "post_attachment_files[1]"
    When I follow "Add Attachment"
    And I select the file "features/support/image.jpg" to upload for "post_attachment_files[2]"
    When I follow "Add Attachment"
    And I select the file "features/support/image.jpg" to upload for "post_attachment_files[3]"
    When I follow "Add Attachment"
    And I select the file "features/support/image.jpg" to upload for "post_attachment_files[4]"
    Then I should not see "Add Attachment"
  
  @test_first
  Scenario: There should be a paperclip icon next to each post link
    Given everything is setup to create posts
    And I am on the new post page with a point of interest and post type "Events"
    When I fill in "post_headline" with "Oh Emm Gee - It's an EVENT!"
    And I fill in "post_short_headline" with "Yeah, I said it!"
    And I fill in "lat" with "31.5124"
    And I fill in "lng" with "-112.854"
    And I fill in "event_starts_at_date" with "3/1/2010"
    And I fill in "event_starts_at_time" with "1:00 AM"
    And I fill in "event_ends_at_date" with "3/1/2011"
    And I fill in "event_ends_at_time" with "1:00 AM"
    And I fill in "post_body" with "I like-a da news. It-a gives me da edge on wass-a happenin"
    And I follow "Add Attachment"
    And I select the file "features/support/image.jpg" to upload for "post_attachment_files[1]"
    And I check "post_certification"
    And I press "Post"
    And I should see "Post created."
    Then there should be an image named "paperclip.png"
  

  #   
  # Scenario: Attaching one file to a news post
  #   Given everything is setup to create posts
  #   Given I am on the new post page with a point of interest and post type "News"
  #   Then show me the page
  #   When I fill in "post_headline" with "Oh Emm Gee - It's NEWS!"
  #   And I fill in "post_short_headline" with "Yeah, I said it!"
  #   And I fill in "lat" with "31.5124"
  #   And I fill in "lng" with "-112.854"
  #   And I fill in "post_body" with "I like-a da news. It-a gives me da edge on wass-a happenin"
  #   Then I follow "Add Attachment"
  #   And I select the file "features/support/image.jpg" to upload for "post_attachment_files[1]"
  #   Then I check "post_certification"
  #   When I press "Post"
  #   Then I should see "Post created."