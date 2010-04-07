Feature: Tweets

  @test_first @rack_test
  Scenario: (Test First) Hiding bad tweets
    Given there is a typus user with email "admin@test.com" and password "columbia"
    And I am logged in as typus user "admin@test.com" with password "columbia"
    And there is a post "Tweet Me"
    And there is a tweet "My Tweet"
    And I am on the admin dashboard
    And I follow "Tweets"
    And I follow "Edit"
    When I check "hide tweet"
    And I press "Update entry"
    Then I should see "Tweet successfully updated."
    When I follow "Back to list"
    Then I should not see "My Tweet"