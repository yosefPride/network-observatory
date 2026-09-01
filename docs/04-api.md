# 04 — API

## Purpose

Expose Network Observatory through an HTTP API.

In the previous stages, the application could discover devices and persist observations, but interaction happened primarily through the command line and internal Python code.

This stage introduces a web server and establishes the application's API boundary.

The API will be built with:

* FastAPI
* Uvicorn
* Pydantic
* HTTP
* REST
* OpenAPI
* Postman

The API should expose the functionality that already exists rather than moving application logic into HTTP route handlers.

---

# Objectives

By the end of this stage, understand and implement:

* HTTP fundamentals
* HTTP methods
* HTTP status codes
* Request/response lifecycle
* REST API design
* FastAPI
* Uvicorn
* ASGI
* Pydantic
* Request validation
* Response serialization
* Dependency injection
* Error handling
* OpenAPI
* API testing with Postman

---

# 1. HTTP Fundamentals

Before building endpoints, understand the protocol underneath FastAPI.

Learn:

* Client
* Server
* Request
* Response
* URL
* Path
* Query parameters
* Headers
* Body
* HTTP methods
* Status codes
* Content types

Understand the basic lifecycle:

```text
Client
   │
   │ HTTP request
   ▼
Server
   │
   │ HTTP response
   ▼
Client
```

Understand what actually travels over the network when the browser or Postman communicates with the API.

---

# 2. HTTP Methods

Understand the intended semantics of the common methods:

```text
GET
POST
PUT
PATCH
DELETE
```

Relate them to Network Observatory operations.

For example:

```text
GET     /devices
GET     /devices/{id}

POST    /scans

GET     /scans/{id}

GET     /devices/{id}/services
GET     /devices/{id}/events
```

The exact API design is your responsibility.

Do not create endpoints simply because a particular tutorial uses them.

---

# 3. HTTP Status Codes

Learn the purpose of status-code categories:

```text
2xx — successful request
3xx — redirection
4xx — client error
5xx — server error
```

Become familiar with statuses such as:

```text
200 OK
201 Created
204 No Content
400 Bad Request
401 Unauthorized
403 Forbidden
404 Not Found
409 Conflict
422 Unprocessable Content
500 Internal Server Error
```

Determine which status code is appropriate for each API situation.

Do not return `200 OK` for every possible outcome.

---

# 4. FastAPI

Introduce FastAPI into the backend.

The initial server should be deliberately small.

Conceptually:

```text
HTTP Request
      ↓
FastAPI
      ↓
Application logic
      ↓
Persistence
      ↓
HTTP Response
```

The FastAPI layer should not contain the implementation of:

* Network discovery
* Database queries
* Business rules

It should coordinate those operations.

---

# 5. Uvicorn and ASGI

Run the FastAPI application using Uvicorn.

Understand the roles of:

```text
FastAPI
Uvicorn
ASGI
```

The conceptual relationship should be clear:

```text
HTTP client
     ↓
Uvicorn
     ↓
ASGI
     ↓
FastAPI
     ↓
Application
```

Understand that FastAPI is the web framework/application layer while Uvicorn is an ASGI server capable of running that application.

Learn how the development server is started and how host/port configuration affects accessibility.

---

# 6. API Structure

Organize the API around application resources.

Potential resources include:

```text
devices
services
scans
events
networks
```

Start with a small number of endpoints.

For example:

```text
GET /devices
GET /devices/{id}

GET /services
GET /devices/{id}/services

POST /scans
GET /scans
GET /scans/{id}

GET /events
GET /devices/{id}/events
```

The final structure should be based on the application's domain rather than being copied from this example.

---

# 7. Pydantic

Use Pydantic for API data validation and serialization.

Distinguish between:

```text
HTTP request data
       ↓
Pydantic model
       ↓
Application logic
       ↓
Domain/persistence data
```

and:

```text
Database data
       ↓
Application logic
       ↓
Pydantic response model
       ↓
HTTP response
```

Create explicit models for API inputs and outputs.

Examples might include:

```text
DeviceResponse
ServiceResponse
ScanResponse
ScanRequest
EventResponse
```

The exact models should be derived from the API you design.

---

# 8. Request Validation

The API should reject invalid input before passing it into application logic.

Examples:

```text
Invalid device ID
Invalid IP address
Invalid CIDR network
Invalid port
Invalid scan configuration
Invalid query parameter
```

Understand the difference between:

```text
valid HTTP request
```

and:

```text
valid application request
```

Use Pydantic and FastAPI's validation mechanisms where appropriate.

---

# 9. Response Models

Define what each endpoint promises to return.

Avoid returning arbitrary internal Python objects directly.

For example:

```text
Database model
      ↓
Application/domain object
      ↓
Response model
      ↓
JSON
```

This creates an explicit API contract.

Consider:

* Which fields should be exposed?
* Which fields should remain internal?
* Which fields can be optional?
* What should nested resources look like?
* How should timestamps be represented?

---

# 10. Dependency Injection

Learn FastAPI's dependency system.

Identify functionality that endpoints need to share.

Potential examples:

```text
Database connection
Configuration
Current user
Application state
```

Understand how dependencies allow common functionality to be provided to route handlers without manually constructing everything inside every endpoint.

Do not introduce dependencies solely for abstraction's sake.

---

# 11. Application Errors

Define how application failures become HTTP responses.

For example:

```text
Device does not exist
        ↓
404 Not Found
```

or:

```text
Invalid scan configuration
        ↓
400 / 422
```

or:

```text
Database unavailable
        ↓
appropriate server error
```

Do not expose internal exception details or database errors directly to clients.

The API should provide useful errors without leaking implementation details.

---

# 12. REST Resource Design

Design the API around resources rather than implementation functions.

Prefer concepts such as:

```text
GET /devices
```

over exposing internal implementation details such as:

```text
GET /run-device-query
```

Think about:

* Resource naming
* Nesting
* Identifiers
* Collection endpoints
* Individual resources
* Filtering
* Pagination
* Sorting

Not all of these need to be implemented immediately.

The purpose is to develop an understanding of API design before the API becomes large.

---

# 13. Filtering and Query Parameters

Introduce query parameters where they make sense.

For example:

```text
GET /devices?status=online
```

or:

```text
GET /events?device_id=...
```

or:

```text
GET /devices?limit=20&offset=0
```

The exact parameters are your decision.

Consider:

* Validation
* Defaults
* Maximum values
* Database query efficiency

Avoid implementing arbitrary filtering functionality without a clear use case.

---

# 14. API and Existing Application Logic

The API should reuse the functionality developed in previous stages.

The architecture should conceptually become:

```text
                    ┌─────────────┐
                    │ CLI         │
                    └──────┬──────┘
                           │
                           ▼
                    Application Logic
                           ▲
                           │
                    ┌──────┴──────┐
                    │ FastAPI     │
                    └──────┬──────┘
                           │
                           ▼
                       HTTP API
```

Both the CLI and API should be able to use the same underlying application functionality.

Do not create a second implementation of the scanner specifically for the API.

---

# 15. OpenAPI

Explore the OpenAPI specification generated by FastAPI.

Understand how your Python definitions become an API description.

Investigate:

```text
paths
operations
parameters
request bodies
responses
schemas
status codes
```

Use the automatically generated documentation to inspect your API.

Understand the difference between:

```text
API implementation
```

and:

```text
API specification
```

The OpenAPI document describes the interface that clients can use.

---

# 16. Postman

Use Postman as an independent API client.

Create requests for the API.

Test:

```text
successful requests
invalid requests
missing resources
invalid parameters
server errors
```

Do not rely exclusively on FastAPI's interactive documentation.

Postman gives you a separate client through which you can test the API contract.

Create a Postman collection for Network Observatory.

---

# 17. Testing

Add automated API tests.

Test at least:

### Devices

```text
GET /devices
GET /devices/{id}
```

Test:

* Existing device
* Missing device
* Empty result

### Scans

```text
POST /scans
GET /scans
GET /scans/{id}
```

Test:

* Valid request
* Invalid request
* Missing scan

### Services

Test:

* Existing device
* Device with no services
* Missing device

### Validation

Test invalid:

```text
IDs
IPs
CIDR ranges
ports
query parameters
request bodies
```

Tests should verify both response data and HTTP status codes.

---

# 18. API Documentation

Update the project documentation as the API develops.

Create:

```text
docs/api-reference.md
```

Document:

* Endpoint
* HTTP method
* Parameters
* Request body
* Response
* Status codes
* Errors

Do not manually duplicate information unnecessarily when OpenAPI already provides it.

The purpose of this document is to explain the API at a conceptual level and record design decisions.

---

# 19. Milestones

## Milestone 1 — HTTP

Understand requests, responses, methods, headers, bodies, and status codes.

---

## Milestone 2 — FastAPI

Run the first FastAPI application with Uvicorn.

---

## Milestone 3 — Read API

Expose persisted information through GET endpoints.

```text
devices
services
scans
events
```

---

## Milestone 4 — Write API

Introduce endpoints that trigger or create application state.

For example:

```text
POST /scans
```

---

## Milestone 5 — Validation

Add Pydantic request and response models.

---

## Milestone 6 — Error Handling

Implement consistent API error responses.

---

## Milestone 7 — Filtering

Add useful query parameters and validate them.

---

## Milestone 8 — OpenAPI

Inspect and understand the generated OpenAPI specification.

---

## Milestone 9 — Postman

Create a Postman collection and test the API independently.

---

## Milestone 10 — Automated Tests

Add automated API tests covering normal and failure cases.

---

# Completion Criteria

Stage 4 is complete when:

* FastAPI runs successfully through Uvicorn.
* The API exposes the important application resources.
* The API uses the existing application logic rather than duplicating it.
* Requests are validated.
* Responses use explicit schemas.
* Appropriate HTTP status codes are returned.
* Application errors are converted into useful API errors.
* API endpoints support appropriate filtering/query parameters.
* OpenAPI accurately describes the API.
* The API can be exercised independently through Postman.
* Automated tests cover the primary endpoints and failure cases.
* The API design is documented.

You should be able to explain:

* What HTTP is.
* What happens during an HTTP request.
* The difference between GET, POST, PUT, PATCH, and DELETE.
* What an HTTP status code represents.
* What FastAPI provides.
* What Uvicorn provides.
* What ASGI is.
* How a request reaches a FastAPI route.
* Why request and response models are useful.
* What Pydantic does.
* What dependency injection means in FastAPI.
* What OpenAPI represents.
* Why an API should not expose internal database models directly.
* Why API tests should not depend exclusively on the browser or FastAPI's documentation UI.

---

# Result

The architecture should now conceptually look like:

```text
                    ┌──────────────┐
                    │   Browser    │
                    └──────┬───────┘
                           │
                           │ HTTP
                           ▼
                    ┌──────────────┐
                    │   Uvicorn    │
                    └──────┬───────┘
                           │
                           │ ASGI
                           ▼
                    ┌──────────────┐
                    │   FastAPI    │
                    └──────┬───────┘
                           │
                           ▼
                    Application Logic
                           │
                           ▼
                    Persistence Layer
                           │
              ┌────────────┼────────────┐
              ▼            ▼            ▼
         PostgreSQL     MongoDB       Redis
```

The system now has a proper HTTP boundary.

The frontend can be built against this API in Stage 6, while Postman provides an independent way to interact with and test it before the frontend exists.
