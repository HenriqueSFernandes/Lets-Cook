<!-- Template file for README.md for LEIC-ES-2023-24 -->

> [!NOTE] In this file you can find the structure to use to document your app as a product in the README.md file. Along the file you will find guidelines that you can delete or comment

# Let's Cook Development Report

Welcome to the documentation pages of the Let's Cook App!

You can find here details about the the Let's Cook App, from a high-level vision to low-level implementation decisions, a kind of Software Development Report, organized by type of activities:

* [Business modeling](#Business-Modelling)
    * [Product Vision](#Product-Vision)
    * [Features and Assumptions](#Features-and-Assumptions)
    * [Elevator Pitch](#Elevator-pitch)
* [Requirements](#Requirements)
    * [User stories](#User-stories)
    * [Domain model](#Domain-model)
* [Architecture and Design](#Architecture-And-Design)
    * [Logical architecture](#Logical-Architecture)
    * [Physical architecture](#Physical-Architecture)
    * [Vertical prototype](#Vertical-Prototype)
* [Project management](#Project-Management)

Contributions are expected to be made exclusively by the initial team, but we may open them to the community, after the course, in all areas and topics: requirements, technologies, development, experimentation, testing, etc.

Please contact us!

Thank you!

## Authored by :
- Allan Santos (up202109243)
- Filipe Gaio (up202204985)
- Henrique Fernandes (up202204988)
- José Sousa (up202208817)
- Leandro Martins (up202208001)

---
## Business Modelling

### Product Vision

Let's Cook is a revolutionary mobile application designed to connect students within FEUP to buy and sell homemade meals, reducing food waste while fostering a sense of community and culinary exploration. Targeted specifically towards students, Let's Cook addresses the common issue of excess food and tight budgets by providing a platform for convenient and sustainable food sharing.


### Features and Assumptions

- Sign In Page and Sign Up Page
- Home Page
- Menu for navigation
- User profile
- Search bar with many filters ( food restrictions or diets, location preferences, price filtering , ratings and cook)
- Scrolldown list of offers with a appealing photo, price, rating, cook
- Dish Page extended version of the menu
- Cook Page photo,description, experience, rating
- About Page

### Elevator Pitch
Draft a small text to help you quickly introduce and describe your product in a short time (lift travel time ~90 seconds) and a few words (~800 characters), a technique usually known as elevator pitch.

Take a look at the following links to learn some techniques:
* [Crafting an Elevator Pitch](https://www.mindtools.com/pages/article/elevator-pitch.htm)
* [The Best Elevator Pitch Examples, Templates, and Tactics - A Guide to Writing an Unforgettable Elevator Speech, by strategypeak.com](https://strategypeak.com/elevator-pitch-examples/)
* [Top 7 Killer Elevator Pitch Examples, by toggl.com](https://blog.toggl.com/elevator-pitch-examples/)


## Requirements

In this section, you should describe all kinds of requirements for your module: functional and non-functional requirements.

### Domain model

![alt text](<Screenshot from 2024-03-15 10-15-11.png>)

#### User

A user is basically a uni student who's either buying or selling food. They could be someone just looking for a quick meal without cooking or a budding chef wanting to share their tasty creations and earn some cash. Each user has a profile with stuff like their name, ID, if they're active or not, and where they are on campus. Plus, they can share a bit about themselves, their food tastes, and what they're selling or looking to buy.

#### Seller:

In the "Let's Cook" app, a seller is typically a university student eager to share their culinary skills and earn some extra money. They could be a passionate cook who loves experimenting with flavors or a student with a knack for preparing delicious homemade meals. Each seller has in addition to the User fiels, a sellerId, a deliverRadius (in which area they deliver food), their average rating, their specialities and their sales record
#### Buyer:
In the "Let's Cook" app, a buyer is essentially a university student seeking convenient and tasty food options within their campus community. They could be a busy student looking for quick meals without the hassle of cooking or someone craving homemade dishes prepared by talented peers. Each buyer has in addition to the user fields, a BuyerId and its BuyingHistory

#### Admin:
In the "Let's Cook" app, an admin plays a crucial role in ensuring smooth operations and maintaining a safe and enjoyable experience for all users. Admins are responsible for managing the platform, monitoring user activity, and addressing any issues or concerns that may arise. They could be university staff members or trusted individuals designated to oversee the app's functionalities. They have a GodToken which gives them those privileges and they can ban anyone and allow users to sell products.

#### Dish :
In the "Let's Cook" app, a dish is the star of the show, enticing buyers with its delicious flavors and enticing presentations. Each dish listed on the platform represents a culinary creation crafted by a talented seller within the university community.

## Architecture and Design
The architecture of a software system encompasses the set of key decisions about its overall organization.

A well written architecture document is brief but reduces the amount of time it takes new programmers to a project to understand the code to feel able to make modifications and enhancements.

To document the architecture requires describing the decomposition of the system in their parts (high-level components) and the key behaviors and collaborations between them.

In this section you should start by briefly describing the overall components of the project and their interrelations. You should also describe how you solved typical problems you may have encountered, pointing to well-known architectural and design patterns, if applicable.

### Logical architecture
The purpose of this subsection is to document the high-level logical structure of the code (Logical View), using a UML diagram with logical packages, without the worry of allocating to components, processes or machines.

It can be beneficial to present the system in a horizontal decomposition, defining layers and implementation concepts, such as the user interface, business logic and concepts.

![img.png](img.png)
### Physical architecture
The goal of this subsection is to document the high-level physical structure of the software system (machines, connections, software components installed, and their dependencies) using UML deployment diagrams (Deployment View) or component diagrams (Implementation View), separate or integrated, showing the physical structure of the system.

It should describe also the technologies considered and justify the selections made. Examples of technologies relevant for ESOF are, for example, frameworks for mobile applications (such as Flutter).

Example of _UML deployment diagram_ showing a _deployment view_ of the Eletronic Ticketing System (please notice that, instead of software components, one should represent their physical/executable manifestations for deployment, called artifacts in UML; the diagram should be accompanied by a short description of each node and artifact):

![DeploymentView](https://user-images.githubusercontent.com/9655877/160592491-20e85af9-0758-4e1e-a704-0db1be3ee65d.png)

### Vertical prototype
To help on validating all the architectural, design and technological decisions made, we usually implement a vertical prototype, a thin vertical slice of the system integrating as much technologies we can.

In this subsection please describe which feature, or part of it, you have implemented, and how, together with a snapshot of the user interface, if applicable.

At this phase, instead of a complete user story, you can simply implement a small part of a feature that demonstrates thay you can use the technology, for example, show a screen with the app credits (name and authors).


## Project management
Software project management is the art and science of planning and leading software projects, in which software projects are planned, implemented, monitored and controlled.

In the context of ESOF, we recommend each team to adopt a set of project management practices and tools capable of registering tasks, assigning tasks to team members, adding estimations to tasks, monitor tasks progress, and therefore being able to track their projects.

Common practices of managing iterative software development are: backlog management, release management, estimation, iteration planning, iteration development, acceptance tests, and retrospectives.

You can find below information and references related with the project management in our team:

* Backlog management: Product backlog and Sprint backlog in a [Github Projects board](https://github.com/orgs/FEUP-LEIC-ES-2023-24/projects/64);
* Release management: [v0](#), v1, v2, v3, ...;
* Sprint planning and retrospectives:
    * plans: screenshots of Github Projects board at begin and end of each iteration;
    * retrospectives: meeting notes in a document in the repository;
 