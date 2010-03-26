Feature: Search
  In order find awesome content
  As a guest or user
  I want to be able to tell you what I want and see it
  
  @index_me
  Scenario: Basic text search
    Given there is a user with the email "steve.swedler@integrumtech.com"
    Given there is a map called "Map 1" with "3" layers created by "steve.swedler@integrumtech.com"
    Given there is a collection of map icons created by "steve.swedler@integrumtech.com"
    Given there is a "Events" post type on "Layer Title 0" with a "news" icon
    Given there is a point of interest called "Interesting Point" on "Map 1" map at "Layer Title 0" layer with "news" icon created by "steve.swedler@integrumtech.com"
    Given there is a post called "My Post" of type "Events" for point of interest "Interesting Point" created by "steve.swedler@integrumtech.com"
    Given I am on the homepage
    When  I search for "post"
    Then  I should see "My Post"