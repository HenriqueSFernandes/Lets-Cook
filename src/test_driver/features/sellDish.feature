Feature: Adding a new dish

Scenario: User adds a new dish with all required details
Given the user is on the "Add a New Dish" page
When the user fills in the following details:
| Field | Value |
| Photo | [path to the photo] |
| Name | [dish name] |
| Ingredients | [list of ingredients] |
| Categories | [categories] |
| Quantity | [quantity] |
| Price | [price] |
| Date | [date] |
And the user submits the form
Then the new dish should be successfully added