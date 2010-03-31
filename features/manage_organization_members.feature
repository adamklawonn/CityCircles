Feature: Managing Organization Features

  @test_first
  Scenario: Add a new organization member (with all details)
    Given I have setup my homepage
    And there is a user with the username "test" and password "password"
    And there is an organization called "Ben's Trikes"
    And the user with username "test" is part of the "Ben's Trikes" organization
    And I am on the home page
    And  I follow "sign in"
    And  I fill in "user_session_login" with "test"
    And  I fill in "user_session_password" with "password"
    And  I press "Login"
    Then I should see "my profile"
    When I follow "my profile"
    Then I should see "edit profile"
    And I should see "Add Members to my Organization"
    When I follow "Add Members to my Organization"
    Then I should see "Add New Member"
    And I fill in "user_first_name" with "Mike"
    And I fill in "user_last_name" with "Benner"
    And I fill in "user_email" with "mike.benner@integrumtech.com"
    And I fill in "user_cell_phone" with "555-1212"
    And I press "Done!"
    Then I should see "Thank you! Your new members will receive a welcome email shortly."
    And I should be on the "test" profile page
    
  @test_first
  Scenario: Add a new organization member (missing details)
    Given I have setup my homepage
    And there is a user with the username "test" and password "password"
    And there is an organization called "Ben's Trikes"
    And the user with username "test" is part of the "Ben's Trikes" organization
    And I am on the home page
    And  I follow "sign in"
    And  I fill in "user_session_login" with "test"
    And  I fill in "user_session_password" with "password"
    And  I press "Login"
    Then I should see "my profile"
    When I follow "my profile"
    Then I should see "edit profile"
    And I should see "Add Members to my Organization"
    When I follow "Add Members to my Organization"
    Then I should see "Add New Member"
    And I fill in "user_first_name" with "Mike"
    And I fill in "user_last_name" with "Benner"
    And I fill in "user_email" with ""
    And I fill in "user_cell_phone" with "555-1212"
    And I press "Done!"
    Then I should see "Oops! Your forgot some information. Please complete the form to continue."
    
  @test_first
  Scenario: Removing an organization member
    Given There is an organization member
    Then I should see "Organization Members"
    When I follow "Organization Members"
    Then I should see "Mike Benner"
    When I follow "Remove"
    Then I should see "Are you sure you want to remove Mike Benner from Bens Trikes"
    When I follow "Yes"
    Then I should see "Member successfully removed"
    And I should see "There are no members in your organization."