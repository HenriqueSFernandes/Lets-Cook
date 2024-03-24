Feature: Filters

Scenario: User filters dishes by specific criteria
Given the user is on the home page
When the user selects a filter option such as "Gluten-Free" or "Vegan"
And the user submits the filter selection
Then the user should be presented with a filtered list of dishes based on the selected filter option
And each dish in the list should meet the selected criteria
And the list of filtered dishes should be sorted based on relevance or popularity
