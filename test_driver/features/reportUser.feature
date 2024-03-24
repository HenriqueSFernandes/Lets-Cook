Feature: Report Users

Scenario: User reports another user for various reasons
Given the user is logged in
And the user is viewing another user's profile
When the user encounters an issue with the other user
And the user chooses to report the other user
Then the user should be able to select the reason for the report
And provide additional details if necessary
And the report should be submitted successfully