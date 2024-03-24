Feature: Navigation Bar with Icons

Scenario: User navigates through the pages using icons on the navigation bar
Given the user is logged into the application
When the user is on any page of the application
Then the user should see a navigation bar with three icons
And the icons should represent the home page, adding a new meal, and profile/settings
When the user clicks on the home page icon
Then the user should be redirected to the home page
When the user clicks on the icon for adding a new meal
Then the user should be redirected to the page for adding a new meal
When the user clicks on the icon for profile/settings
Then the user should be redirected to the profile and settings page