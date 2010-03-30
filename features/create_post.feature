Feature: Create post
  In order add content to the site
  As a user
  I want to add posts to the site

  @wip
  Scenario: Create a post
    Given I have setup my homepage
    Given I have a point of interest "My POI"
    Given there is a user with the username "test" and password "secret"
    And   I am logged in as "test" with password "secret"
    Given I am on the new post page with a point of interest and post type "Events"
    When  I fill in "post_headline" with "New Post"
    And   I fill in "post_short_headline" with "New Post Short Headline"
    And   I fill in "post_body" with "Text"
    And   I fill in "lat" with "33.52143305339792"
    And   I fill in "lng" with "-112.09749269590247"
    And   I check "post_certification"
    When  I press "Post"
    
    # location
    # If I do not complete this and click "Post," I should see messages near the empty fields: "Can't be blank" for headlines, and "You must choose location" for map.


  # Given I am a registered CC user and logged in
  # 
  #   ISBAT to click on a stop on the map and go to that stop page
  # 
  #   And ISBAT to click on the "+" icon near any content category* edit  New  * denotes special case where "Biz Promos" is restricted to merchant access only,
  #    not general members. This story will be identical for merchants, except they can post to this field exclusively. edit    new comment [x]
  # 
  #   When I click the + sign, I should see the post page
  # 
  # 
