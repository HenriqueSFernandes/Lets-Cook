Feature: Chatting with the Cooker

Scenario: User initiates a chat with the cooker
Given the user is logged in
And the user is viewing a dish they want to inquire about
When the user selects the option to chat with the cooker
Then the user should be directed to a chat interface with the cooker
And the user should be able to send messages to the cooker
And the cooker should be able to respond to the user's messages
