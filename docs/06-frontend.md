# 06 — Frontend

## Purpose

Build the web interface for Network Observatory using vanilla HTML, CSS, and JavaScript.

The backend, API, persistence layer, and authentication system already exist.

This stage connects those components to a browser-based interface.

The frontend should allow a user to:

* Log in
* View their network
* View discovered devices
* Inspect device information
* View services
* View historical events
* Start scans
* Monitor scan progress
* View scan results

The frontend should communicate with the FastAPI backend exclusively through the HTTP API.

Do not bypass the API by accessing the database directly.

---

# Objectives

By the end of this stage, understand and implement:

* HTML
* CSS
* JavaScript
* DOM
* Browser events
* Forms
* Fetch API
* JSON
* HTTP from the browser
* Authentication from a frontend
* Client-side state
* Dynamic rendering
* Error handling
* Loading states
* Responsive design
* Browser storage
* Basic frontend architecture

---

# 1. Frontend Architecture

Establish the relationship between the browser and the backend.

The architecture should be:

```text id="xw2v6d"
Browser
   │
   │ HTTP / JSON
   ▼
FastAPI
   │
   ▼
Application
   │
   ▼
Database
```

The frontend should not communicate directly with:

```text id="pl0e6m"
PostgreSQL
MongoDB
Redis
```

The API is the boundary between the frontend and backend.

---

# 2. HTML

Build the initial application structure using semantic HTML.

Learn and use:

* Document structure
* Semantic elements
* Forms
* Inputs
* Buttons
* Tables
* Lists
* Links
* Sections
* Labels
* Accessibility attributes

The application should have a meaningful document structure rather than being composed primarily of generic `<div>` elements.

---

# 3. Application Pages

Define the initial interface.

Potential pages/views include:

```text id="k8d5y3"
Login
Dashboard
Devices
Device Detail
Scans
Scan Detail
Events
```

The exact navigation structure is your decision.

You do not need a frontend framework or client-side router.

Determine how navigation between views should work using standard browser capabilities and JavaScript.

---

# 4. Login

Build the login interface.

The user should be able to:

```text id="1nqj8w"
Enter credentials
      ↓
Submit form
      ↓
API request
      ↓
Receive authentication token
      ↓
Authenticated application
```

Handle:

* Successful login
* Invalid credentials
* Validation errors
* Network failures
* Loading state

Do not expose authentication errors unnecessarily.

---

# 5. Authentication in the Browser

Determine how the frontend should maintain authentication state.

Investigate browser mechanisms such as:

* Cookies
* Local storage
* Session storage
* In-memory state

Understand the security tradeoffs of each.

The frontend must be able to make authenticated API requests after login.

Conceptually:

```text id="lx6y7c"
Login
  ↓
Authentication
  ↓
Authentication state
  ↓
API requests
```

Do not treat storing a JWT in the browser as a trivial implementation detail.

Understand the security implications of your chosen approach.

---

# 6. JavaScript

Use JavaScript to provide application behavior.

Learn:

* Variables
* Functions
* Objects
* Arrays
* Modules
* Promises
* `async` / `await`
* Error handling
* Events
* DOM manipulation

Keep JavaScript separated from HTML where practical.

Avoid putting large amounts of JavaScript directly inside HTML attributes or `<script>` blocks.

---

# 7. DOM

Use the DOM to create a dynamic interface.

Learn:

* Selecting elements
* Creating elements
* Modifying elements
* Removing elements
* Attributes
* Classes
* Text content
* Event listeners
* Form interaction

For example:

```text id="l4d2gd"
API response
     ↓
JavaScript
     ↓
DOM
     ↓
Updated interface
```

The interface should be generated from application state rather than hard-coded copies of API data.

---

# 8. Fetch API

Use the browser's Fetch API to communicate with FastAPI.

Create a small client-side API layer rather than scattering raw `fetch()` calls throughout the UI.

Conceptually:

```text id="0smg1h"
UI
 ↓
API client
 ↓
HTTP
 ↓
FastAPI
```

The API client should handle common concerns such as:

* Request creation
* Headers
* Authentication
* JSON serialization
* JSON parsing
* HTTP errors

---

# 9. Devices View

Create the primary network view.

Display information such as:

```text id="j06hmb"
Device
├── IP address
├── MAC address
├── Hostname
├── Status
└── Last seen
```

The data should come from the API.

Do not hard-code discovered devices into the frontend.

---

# 10. Device Detail

Allow a user to inspect an individual device.

Display appropriate information such as:

```text id="fuwi7b"
Device
├── Identity
├── Network information
├── Services
└── History
```

The user should be able to navigate from the device list to the device detail view.

---

# 11. Services

Display discovered services for a device.

For example:

```text id="4m8i8g"
Port     Protocol     State
22       TCP          Open
80       TCP          Open
443      TCP          Closed
```

The frontend should represent the actual API data rather than making assumptions about which ports exist.

---

# 12. Scan Interface

Create an interface for starting a network scan.

The user should be able to provide the necessary scan parameters.

Conceptually:

```text id="k2q9cy"
Network
    ↓
Start Scan
    ↓
API
    ↓
Scanner
```

Handle:

* Invalid input
* Scan already running
* Permission denied
* Server errors
* Successful scan creation

---

# 13. Scan Status

If scans are not instantaneous, the frontend needs to represent their state.

Potential states:

```text id="d71qbw"
Pending
Running
Completed
Failed
Cancelled
```

The interface should communicate the current state clearly.

Investigate how the frontend can obtain updated state.

Possible approaches include:

* Polling
* Long polling
* Server-sent events
* WebSockets

You do not need to implement all of them.

Choose an approach appropriate for the current application and understand its tradeoffs.

---

# 14. Events and History

Create a view for historical network events.

Display useful information such as:

```text id="v6w47q"
Timestamp
Device
Event
Details
```

Examples:

```text id="5ytzj4"
Device discovered
Device became unavailable
Service discovered
Service disappeared
Hostname changed
```

The frontend should make changes over time understandable to the user.

---

# 15. Dashboard

Create a high-level dashboard.

The dashboard should provide a quick overview of the network.

Potential information:

```text id="35z7fr"
Devices
Services
Online devices
Offline devices
Recent scans
Recent events
```

Do not attempt to build a complex analytics dashboard yet.

The goal is to make the data already produced by the backend useful to a human.

---

# 16. Loading States

Network requests take time.

Every asynchronous operation should have an appropriate loading state.

For example:

```text id="n5xbyh"
Loading devices...
Loading scan...
Starting scan...
```

Avoid interfaces that appear frozen while waiting for the API.

---

# 17. Error States

Design explicit error states.

Examples:

```text id="04gkjq"
Network unavailable
Authentication expired
Permission denied
Resource not found
Invalid input
Server error
```

The user should receive a useful explanation and, where appropriate, an action they can take.

Do not display raw backend exceptions.

---

# 18. Empty States

Handle cases where the API returns no data.

For example:

```text id="9knb9y"
No devices discovered.
```

or:

```text id="6m2rfl"
No services have been observed for this device.
```

An empty state is different from an error.

The interface should distinguish:

```text id="u3x2t7"
No data
```

from:

```text id="q2ozm9"
Could not retrieve data
```

---

# 19. CSS

Create the application's visual design using CSS.

Learn and use:

* Selectors
* Cascade
* Specificity
* Box model
* Display
* Positioning
* Flexbox
* Grid
* Responsive design
* Media queries
* CSS variables
* States
* Transitions where appropriate

Avoid introducing a CSS framework.

The purpose of this project is to understand the underlying technologies.

---

# 20. Responsive Design

The application should remain usable at different viewport sizes.

Test at least:

```text id="m9a8px"
Desktop
Tablet
Mobile
```

Pay particular attention to:

* Tables
* Navigation
* Device details
* Forms
* Dashboard layout

Do not treat mobile support as simply making everything smaller.

---

# 21. Client-Side State

As the frontend becomes more complex, determine what state needs to exist in JavaScript.

Potential state includes:

```text id="o5p7vn"
Current user
Authentication state
Selected device
Devices
Current scan
Scan status
Errors
Loading state
```

Avoid creating a global state system before one is necessary.

First understand the problem that state management is solving.

---

# 22. API Errors and Authentication

Handle authentication failures centrally where practical.

For example:

```text id="x9d3kl"
API request
     ↓
401 Unauthorized
     ↓
Authentication state invalid
     ↓
Return user to login
```

The frontend should not allow an expired or invalid authentication state to silently break every API request.

---

# 23. Browser Developer Tools

Use the browser's developer tools throughout development.

Learn to inspect:

### Elements

Understand the resulting DOM and CSS.

### Console

Inspect JavaScript errors and diagnostic output.

### Network

Inspect:

* Requests
* URLs
* Methods
* Headers
* Request bodies
* Responses
* Status codes
* Timing

### Storage

Inspect:

* Cookies
* Local storage
* Session storage

Do not treat developer tools as merely a debugging utility.

Use them to understand what the browser is actually doing.

---

# 24. Frontend Testing

Introduce testing where useful.

At minimum, test important application behavior such as:

* Login behavior
* API error handling
* Rendering device data
* Form validation
* Navigation
* Authentication state

Since the project uses vanilla JavaScript, determine what level of frontend testing is appropriate without introducing unnecessary tooling.

---

# 25. Accessibility

The application should be usable beyond a mouse and visual interaction.

Pay attention to:

* Semantic HTML
* Labels
* Keyboard navigation
* Focus states
* Button semantics
* Form errors
* Text alternatives
* Color-independent status indicators

Accessibility should be considered while building the interface rather than added at the end.

---

# 26. Milestones

## Milestone 1 — Static Interface

Create the initial HTML and CSS structure.

---

## Milestone 2 — JavaScript

Add DOM interaction and browser-side behavior.

---

## Milestone 3 — API Client

Connect the frontend to the FastAPI API.

---

## Milestone 4 — Authentication

Implement login and authenticated API requests.

---

## Milestone 5 — Devices

Display discovered devices and device details.

---

## Milestone 6 — Services

Display service information for devices.

---

## Milestone 7 — Scans

Allow users to start scans and observe scan state.

---

## Milestone 8 — History

Display historical events and observations.

---

## Milestone 9 — Dashboard

Create a useful high-level network overview.

---

## Milestone 10 — Reliability

Add loading states, error handling, empty states, and authentication failure handling.

---

## Milestone 11 — Responsive UI

Make the application usable across viewport sizes.

---

## Milestone 12 — Testing and Accessibility

Test important behavior and review the interface for accessibility problems.

---

# Completion Criteria

Stage 6 is complete when:

* The frontend is implemented using vanilla HTML, CSS, and JavaScript.
* The browser communicates with the backend exclusively through the API.
* Users can log in.
* Authenticated API requests work.
* Devices can be viewed.
* Device details can be inspected.
* Services can be viewed.
* Historical events can be viewed.
* Users can initiate network scans.
* Scan status can be observed.
* Loading, error, and empty states are handled.
* The dashboard provides a useful overview of the network.
* The interface works at multiple viewport sizes.
* Important frontend behavior has automated tests where appropriate.
* Basic accessibility requirements have been addressed.

You should be able to explain:

* What the DOM is.
* How JavaScript interacts with the DOM.
* How browser events work.
* How `fetch()` communicates with an HTTP API.
* How JSON moves between frontend and backend.
* How asynchronous JavaScript works.
* What a Promise represents.
* How `async`/`await` works.
* How authentication state is maintained in the browser.
* The security tradeoffs of different browser storage mechanisms.
* How CSS specificity and the cascade work.
* When Flexbox and Grid are appropriate.
* How the browser's Network panel can be used to debug API communication.
* The difference between loading, empty, and error states.

---

# Result

The system now has a complete user-facing path:

```text
                         User
                          │
                          ▼
                     Web Browser
                          │
                 HTML / CSS / JS
                          │
                       HTTP
                          │
                          ▼
                     FastAPI API
                          │
                 Authentication
                          │
                   Application
                          │
                          ▼
                    Persistence
                          │
            ┌─────────────┼─────────────┐
            ▼             ▼             ▼
       PostgreSQL      MongoDB        Redis
```

The user can now interact with Network Observatory through a browser rather than directly through the CLI or API.

The application has gone from a collection of backend components to an actual usable product.
