Feature: Wireless profile
  As a user
  I want to be able to manage my wireless devices

  @test_first
  Scenario Outline: See edit my device link
    Given I have setup my homepage
    Given there is a user with the username "test" and password "secret"
    And there is a user with the username "not-test" and password "secret"
    And I am logged in as "<login>" with password "secret"
    Given that I am on the profile page for "test"
    Then I should <action> 
    
    Examples:
      | login    | action                   |
      | test     | see "Edit my device"     |
      | not-test | not see "Edit my device" |

  @test_first
  Scenario: Editing my device
    Given I have setup my homepage
    Given there is a user with the username "test" and password "secret"
    And I am logged in as "test" with password "secret"
    Then show me the page
    Given that I am on the profile page for "test"
    When I follow "Edit My Device"
    Then I should see "Editing wireless device"
    When I select "Verizon"
    And I press "Submit"
    Then I should see "Wireless device successfully updated!"
  
  @test_first
  Scenario: Unsuccessfully editing my device
    Given I have setup my homepage
    Given there is a user with the username "test" and password "secret"
    And I am logged in as "test" with password "secret"
    Given that I am on the profile page for "test"
    When I follow "Edit My Device"
    Then I should see "Editing wireless device"
    When I press "Submit"
    Then I should see "Oops! You're missing some information. Please complete the required fields."
