Feature: As an admin ISBAT moderate organization posts

Background: Set up user and log in
  Given there is a typus user with email "admin@test.com" and password "columbia"
  And I am logged in as typus user "admin@test.com" with password "columbia"

  @test_first
  Scenario: (Test First) Moderating inappropriate organization posts
    Given that here is an organization post "This is inappropriate"
    And I am on the admin dashboard
    And I follow "Organization posts"
    Then I should be on the admin organization posts list page
    And I should see "This is inappropriate"
    When I click "Edit"
    Then I should be on the admin organization edit page for "This is inappropriate"
    When I check "hide"
    And I press "Update entry"
    Then I should be on the admin organization posts list page
    And I should see "Organization post successfully hidden."