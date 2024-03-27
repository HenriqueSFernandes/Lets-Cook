Feature: Search Bar Functionality

Scenario: User searches for a dish or cooker
Given the user is on the homepage
When the user enters a search query in the search bar
And the user submits the search query
Then the user should be presented with search results based on their selection
And each search result should contain the searched keyword in its name or description
And the list of search results should be sorted based on relevance or popularity
