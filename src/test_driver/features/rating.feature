Feature: Rating System for Cookers

Scenario: User rates a cooker after a meal
Given the user has ordered a meal from a cooker
When the user has consumed the meal
And the user chooses to rate the cooker
Then the user should be able to provide a rating from 1-10
And optionally provide additional comments
And the rating should be submitted successfully

Scenario: Average rating is displayed for a cooker
Given multiple users have rated a cooker
When the average rating for the cooker is calculated
Then the average rating should be displayed on the cooker's profile

Scenario: Cooker's overall rating is updated
Given the cooker receives new ratings from users
When the new ratings are added to the existing ratings
Then the cooker's overall rating should be updated accordingly