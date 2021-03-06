Feature: Member managing their interests

  Scenario: Adding interests
    Given there is a user with the username "test" and password "password"
    And I am logged in as "test" with password "password"
    And the following interests:
      | name     |
      | Business |
      | Cars     |
      | Energy   |
    And I am on my settings page
    And I follow "Interests"
    Then I should see "Interest"
    When I select "Cars" from "user_interest_interest_id"
    And I press "Add Interest"
    Then I should see "Interest added."
    And I should see "Cars" within "ul#interest_list"
  
  @test_first
  Scenario: (Test First) Removing interests
    Given there is a user with the username "test" and password "password"
    And I am logged in as "test" with password "password"
    And the following interests:
      | name     |
      | Business |
      | Cars     |
      | Energy   |
    And I have the interest "Cars"
    And I have the interest "Energy"
    And I am on my settings page
    And I follow "Interests"
    Then I should see "Cars"
    And I should see "Energy"
    When I follow "Remove"
    And I should not see "Cars" within "ul#interest_list"
    And I should see "Energy" within "ul#interest_list"
    