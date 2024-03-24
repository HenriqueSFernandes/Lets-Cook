Feature: View Details of Selected Meal

Scenario: User selects a meal and views its details
Given the user is on the meals page
When the user selects a meal from the list
Then the user should be able to view more details about the selected meal
And the user should see the name of the cooker
And the user should see the ratings of the meal
And the user should see a button to send a message to the cooker
And the user should see the price of the meal
And the user should see the date of the meal
And the user should see the list of ingredients of the meal
And the user should see the categories such as vegan, gluten-free, etc. listed for the meal
