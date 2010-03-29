Feature: Wireless profile
  As a user
  I want to be able to manage my wireless devices

  Scenario Outline: See edit my device link
    Given there is a user with the email "test@testuser.com" and password "secret"
    And there is a user with the email "not-test@testuser.com" and password "secret"
    And I am logged in as "<email>" with password "secret"
    Given that I am on the profile page for "test@testuser.com"
    Then I should <action> 
    
    Examples:
      | email                 | action                   |
      | test@testuser.com     | see "Edit my device"     |
      | not-test@testuser.com | not see "Edit my device" |

  Scenario: Editing my device
    Given there is a user with the email "test@testuser.com" and password "secret"
    And I am logged in as "test@testuser.com" with password "secret"
    Given that I am on the profile page for "test@testuser.com"    
    When I follow "Edit My Device"
    Then I should see "Editing wireless device"
    When I select "Verizon"
    And I press "Submit"
    Then I should see "Wireless device successfully updated!"
  
  Scenario: Unsuccessfully editing my device
    Given there is a user with the email "test@testuser.com" and password "secret"
    And I am logged in as "test@testuser.com" with password "secret"
    Given that I am on the profile page for "test@testuser.com"    
    When I follow "Edit My Device"
    Then I should see "Editing wireless device"
    When I press "Submit"
    Then I should see "Oops! You're missing some information. Please complete the required fields."
