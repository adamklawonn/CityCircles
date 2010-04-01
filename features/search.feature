Feature: Search
  In order find awesome content
  As a guest or user
  I want to be able to tell you what I want and see it
  
  Scenario Outline: Basic text search
    Given there is a user with the email "test@testuser.com"
    And   there is a map called "Map 1" with "3" layers created by "test@testuser.com"
    And   there is a collection of map icons created by "test@testuser.com"
    And   there is a "Events" post type on "Layer Title 0" with a "news" icon
    And   there is a point of interest called "Interesting Point" on "Map 1" map at "Layer Title 0" layer with "news" icon created by "test@testuser.com"
    Given there is an event called "My Event"
    Given there is an news post called "My News"
    And   I am on the homepage
    When  I search for "<name>"
    Then  I should <action>
    Examples:
      | name     | action              |
      | My Event | see "My Event"      |
      | My Event | not see "My News"   |
      | My News  | see "My News"       |
      | My News  | not see "My Events" |
    
  @test_first
  Scenario: (Test First) Navigate to the advanced search page
    Given there is a user with the email "test@testuser.com"
    And   there is a map called "Map 1" with "3" layers created by "test@testuser.com"
    And   there is a collection of map icons created by "test@testuser.com"
    And   there is a "Events" post type on "Layer Title 0" with a "news" icon
    And   there is a point of interest called "Interesting Point" on "Map 1" map at "Layer Title 0" layer with "news" icon created by "test@testuser.com"
    And   there is a post called "My Post" of type "Events" for point of interest "Interesting Point" created by "test@testuser.com"
    And   I am on the homepage
    And   I follow "Advanced Search"
    Then  I should see "Advanced Search"
  
  @test_first
  Scenario: (Test First) Search by time
    Given there is an event called "Not My Event" which starts on "1/24/2010" and ends on "1/26/2010"
    And   there is an event called "My Event" which starts on "3/24/2010" and ends on "3/26/2010"
    And   I am on the advanced search page
    When  I select "3/20/2010" from "Start Date"
    And   I select "3/27/2010" from "End Date"
    And   I press "Search"
    Then  I should see "My Event"
    And   I should not see "Not My Event"
    
  @test_first
  Scenario: (Test First) Search by location
    Given there is an event called "My Event" at location "325 E Elliot Rd, Chandler AZ"
    And   I am on the advanced search page
    When  I fill in "location" with "Chandler AZ"
    And   I press "Search"
    Then  I should see "My Event"

  @test_first
  Scenario Outline: (Test First) Search by post type
    Given there is an event called "My Event"
    Given there is an news post called "My News"
    And   I am on the advanced search page
    When  I fill in "post_type" with "<post_type>"
    And   I press "Search"
    Then  I should <action>

    Examples:
      | post_type | action              |
      | Events    | see "My Event"      |
      | Events    | not see "My News"   |
      | News      | see "My News"       |
      | News      | not see "My Events" |
    
  @test_first
  Scenario: Search text should b
    Given there is a user with the email "test@testuser.com"
    And   there is a map called "Map 1" with "3" layers created by "test@testuser.com"
    And   there is a collection of map icons created by "test@testuser.com"
    And   there is a "Events" post type on "Layer Title 0" with a "news" icon
    And   there is a point of interest called "Interesting Point" on "Map 1" map at "Layer Title 0" layer with "news" icon created by "test@testuser.com"
    And   there is a post called "My Post" of type "Events" for point of interest "Interesting Point" created by "test@testuser.com"
    And   I am on the homepage
    When  I search for "Amazing Stuff"
    Then  there should be "Amazing Stuff" in the search history
    
