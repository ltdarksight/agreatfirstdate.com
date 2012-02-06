Feature: Profile page functionality
	In order to use application
	As an user
	I want to have my profile page
	
	Scenario: User sees useful links in his profile page
		Given I have some user
		When I signed in as some user
		Then I should have useful links in page header
		
	
		