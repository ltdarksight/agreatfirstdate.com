@wip
@javascript
Feature: Provide Stripe Card functionality
	In order to access all features
	As an user
	I want to be able to provide my credit card information

	Scenario: User can fill in card details and verify it
		Given I am an authenticated user
    When I go to the edit my profile page
    And I fill in my card details
    And I verify my card
    And stripe fires success web hooks
    Then my card should be verified
    When stripes fires failure web hooks
    Then my card should not be verified