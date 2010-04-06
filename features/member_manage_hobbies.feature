Feature: Member managing their hobbies

  Scenario: Adding hobbies
    Given there is a user with the username "test" and password "password"
    And I am logged in as "test" with password "password"
    And the following hobbies:
      | name       |
      | Baseball   |
      | Basketball |
      | Biking     |
    And I am on my settings page
    And I follow "Hobbies"
    Then I should see "Hobby"
    When I select "Baseball" from "user_hobby_hobby_id"
    And I press "Add Hobby"
    Then I should see "Hobby added."
    And I should see "Baseball" within "ul#hobby_list"
    
  Scenario: Removing hobbies
    Given there is a user with the username "test" and password "password"
    And I am logged in as "test" with password "password"
    And the following hobbies:
      | name       |
      | Baseball   |
      | Basketball |
      | Biking     |
    And I have the hobby "Baseball"
    And I have the hobby "Basketball"
    And I am on my settings page
    And I follow "Hobbies"
    Then I should see "Baseball" within "ul#hobby_list"
    And I should see "Basketball" within "ul#hobby_list"
    When I follow "Remove"
    And I should not see "Baseball" within "ul#hobby_list"
    And I should see "Basketball" within "ul#hobby_list"