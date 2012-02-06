Feature: Home page functionality
	In order to use application
	As an guest
	I want to see some useful links to home page
	
	Scenario: Guest uses home page links
		When I go to home page
		Then I should see "Login"
		And I should see "The Blog"
    	And I should see "FAQ"
    	And I should see "Privacy"
    	And I should see "About"
    	And I should see "Terms of Use"
    
	Scenario: Guest can see two forms
		When I go to home page
		Then Page should have "#new_user"
		Then Page should have "#welcomeRegisterForm"
	
	@javascript
	Scenario: Guest can sign in with right credentials
		Given I have some user
		When I go to home page
		When I enter right credentials in sign in form
		When I click "Welcome back" button
		Then I should get in my profile page
		And I sign out
		
	@javascript
	Scenario: Guest can not sign in with right credentials
		Given I have some user
		When I go to home page
		When I enter wrong credentials in sign in form
		When I click "Welcome back" button
		Then I should not get in my profile page