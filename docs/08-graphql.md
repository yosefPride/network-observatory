# 08 — GraphQL

## Purpose

Introduce GraphQL as an alternative API interface for Network Observatory.

The REST API built in Stage 4 exposes resources through HTTP endpoints.

GraphQL approaches the same problem differently: clients describe the data they want, and the server resolves that request against the application's underlying data.

The goal of this stage is not simply to "add GraphQL."

The goal is to understand:

* Why GraphQL exists
* How GraphQL differs from REST
* Schemas
* Types
* Queries
* Mutations
* Resolvers
* Arguments
* Variables
* Nested data
* Error handling
* GraphQL introspection
* Performance considerations
* GraphQL authorization

The existing REST API should remain functional.

---

# Objectives

By the end of this stage, understand and implement:

* GraphQL
* GraphQL schemas
* Types
* Fields
* Queries
* Mutations
* Arguments
* Variables
* Resolvers
* Nested queries
* Input types
* Response selection
* Introspection
* GraphQL errors
* Authorization
* N+1 queries
* DataLoader-style batching
* REST vs GraphQL tradeoffs

---

# 1. Why GraphQL?

Start by identifying problems that can occur with a traditional REST API.

Consider a request such as:

```text id="5m6t7y"
GET /devices/123
```

The client may receive device information but then need additional requests for:

```text id="y4f9hx"
services
events
availability
```

This can result in multiple requests.

GraphQL approaches the problem differently.

A client can request a shape of data conceptually similar to:

```text id="k4z7fw"
device
├── hostname
├── ip
├── services
│   ├── port
│   └── state
└── recentEvents
    ├── type
    └── timestamp
```

The client specifies which fields it needs.

Understand why this can be useful.

Also understand where GraphQL introduces additional complexity.

---

# 2. REST vs GraphQL

Compare the two approaches using Network Observatory.

For example:

```text id="6y6zq8"
REST

GET /devices/123
GET /devices/123/services
GET /devices/123/events
```

versus:

```text id="j8k2q5"
GraphQL

query {
    device(id: "123") {
        hostname
        ip
        services {
            port
            state
        }
        recentEvents {
            type
            timestamp
        }
    }
}
```

Investigate:

* Number of requests
* Amount of returned data
* Client flexibility
* API complexity
* Caching
* Error handling
* Documentation
* Versioning
* Authorization
* Performance

Do not assume GraphQL is inherently better than REST.

---

# 3. GraphQL Schema

Define the GraphQL schema for Network Observatory.

Start with the domain objects that already exist.

Potential types include:

```text id="5v3c8a"
Device
Service
Scan
Event
Network
User
```

The schema should describe what clients are allowed to request.

Conceptually:

```text id="z9k4q2"
GraphQL Schema
      │
      ├── Types
      ├── Fields
      ├── Queries
      └── Mutations
```

The schema is the public contract between the GraphQL client and server.

---

# 4. GraphQL Types

Define types corresponding to application concepts.

For example:

```text id="4q7k6r"
Device
├── id
├── ip
├── mac
├── hostname
├── status
├── services
└── events
```

Determine:

* Which fields are required
* Which fields are nullable
* Which fields are lists
* Which fields return nested objects
* Which fields should remain private

The GraphQL schema should not simply expose every field in your database.

---

# 5. Queries

Create read operations.

Potential queries include:

```text id="m4g7z1"
devices
device(id)
scans
scan(id)
events
```

Start with simple queries.

Then introduce nested queries.

For example:

```text id="0p5s7c"
device(id: "123") {
    ip
    hostname
}
```

Then:

```text id="4k7f0w"
device(id: "123") {
    ip
    hostname
    services {
        port
        state
    }
}
```

The client should be able to request only the fields it needs.

---

# 6. Resolvers

Understand what a resolver does.

Conceptually:

```text id="8s5w3p"
GraphQL Query
      ↓
Resolver
      ↓
Application Logic
      ↓
Persistence
      ↓
Result
```

Resolvers should not contain large amounts of business logic.

They should connect the GraphQL schema to the application's existing functionality.

The same application logic should be reusable by both:

```text id="v0k2t8"
REST
```

and:

```text id="x7m3q9"
GraphQL
```

---

# 7. Arguments

Allow clients to provide arguments.

For example:

```text id="j6v4b8"
device(id: "123")
```

or:

```text id="k3m9x2"
events(deviceId: "123")
```

Learn how GraphQL arguments differ from REST path and query parameters.

Validate arguments before passing them into application logic.

---

# 8. Variables

Do not hard-code dynamic values directly into GraphQL queries.

Learn how variables work.

Conceptually:

```text id="f6w9j4"
query Device($id: ID!) {
    device(id: $id) {
        hostname
        ip
    }
}
```

with variables supplied separately.

Understand why variables are useful for:

* Reusable queries
* Client applications
* Validation
* Cleaner request construction

---

# 9. Mutations

Introduce operations that modify application state.

Potential mutations:

```text id="7w8m4x"
startScan
```

or:

```text id="9k4s2d"
updateMonitoringConfiguration
```

The exact mutations should be based on actual application requirements.

Understand the distinction between:

```text id="1r3x6b"
Query
→ retrieve data
```

and:

```text id="6q8m0z"
Mutation
→ change state
```

Do not expose every REST POST endpoint as a GraphQL mutation automatically.

---

# 10. Input Types

Use GraphQL input types for complex mutation arguments.

For example:

```text id="3q6x8z"
StartScanInput
├── network
├── ports
└── configuration
```

Determine which values are:

* Required
* Optional
* Lists
* Nested objects

Validate the input at the API boundary.

---

# 11. Nested Data

Take advantage of one of GraphQL's major characteristics: requesting related data in one query.

For example:

```text id="m2p8q1"
devices {
    ip
    hostname

    services {
        port
        state
    }

    recentEvents {
        type
        timestamp
    }
}
```

Investigate what the server must actually do to resolve this request.

This should lead naturally into the performance problems discussed below.

---

# 12. The N+1 Problem

Deliberately investigate the N+1 query problem.

Suppose a query requests:

```text id="9z3h7q"
devices {
    hostname

    services {
        port
    }
}
```

A naïve implementation could result in:

```text id="m5x2a9"
1 query → devices

then:

1 query → services for device 1
1 query → services for device 2
1 query → services for device 3
...
```

This can become extremely inefficient.

Understand:

* Why the problem occurs
* How nested GraphQL fields trigger it
* How batching can reduce database operations
* Why GraphQL makes this issue particularly important

---

# 13. DataLoader / Batching

Investigate a batching mechanism for resolving related data efficiently.

Conceptually:

```text id="7y4m2k"
Device 1 ─┐
Device 2 ─┤
Device 3 ─┼──→ batch request
Device 4 ─┘
               ↓
        database query
```

The implementation should avoid unnecessary repeated database queries.

You do not need to implement an elaborate abstraction if the current dataset does not require one.

The objective is to understand the problem and the solution.

---

# 14. GraphQL Errors

Understand GraphQL's error model.

A GraphQL response can contain both:

```text id="6q0r4x"
data
```

and:

```text id="j5s9v1"
errors
```

Understand how this differs from traditional REST error handling.

Investigate what happens when:

* A resource does not exist
* An argument is invalid
* Authentication fails
* Authorization fails
* A resolver fails
* A database operation fails

Do not expose internal exception details to clients.

---

# 15. Authentication

GraphQL should use the same authentication system established in Stage 5.

The request flow should remain conceptually:

```text id="z6q4m8"
GraphQL Request
      ↓
Authentication
      ↓
Current User
      ↓
Resolver
```

Do not create a separate authentication system for GraphQL.

The authenticated user should be available to resolvers through the application's existing authentication mechanism.

---

# 16. Authorization

Apply the same authorization principles to GraphQL.

Consider a query such as:

```text id="x2q8k3"
device(id: "123") {
    hostname
    events {
        type
    }
}
```

The server must determine whether the authenticated user is allowed to access that device and its associated information.

Do not assume that hiding a field from the frontend constitutes authorization.

Authorization must occur on the server.

---

# 17. GraphQL and the Frontend

Add GraphQL support to the existing frontend.

Do not immediately replace all REST requests.

Start by using GraphQL for selected views.

For example:

```text id="c7m4x8"
Dashboard
    ↓
GraphQL

Device detail
    ↓
GraphQL

Authentication
    ↓
Existing REST API
```

This gives you an opportunity to compare both approaches within the same application.

---

# 18. Query Design

Experiment with different GraphQL queries.

Compare:

### Small query

```text id="7j4p8s"
device {
    hostname
}
```

with:

### Larger query

```text id="5k9m2q"
device {
    hostname
    ip
    services {
        port
        state
    }
    recentEvents {
        type
        timestamp
    }
}
```

Observe:

* Response size
* Number of database operations
* Resolver execution
* Frontend complexity

This is an important part of understanding GraphQL rather than merely learning its syntax.

---

# 19. Introspection

Explore GraphQL introspection.

Understand how a client can discover:

* Available types
* Fields
* Queries
* Mutations
* Arguments
* Types of returned values

Compare this with the OpenAPI documentation from Stage 4.

You should understand that both systems provide machine-readable descriptions of an API, but they approach API discovery differently.

---

# 20. GraphQL Development Tools

Use an appropriate GraphQL client or interactive development environment to inspect and test the API.

Use it to:

* Explore the schema
* Run queries
* Run mutations
* Inspect responses
* Inspect errors
* Experiment with nested queries

Continue using Postman where useful.

The objective is to become comfortable testing an API without relying exclusively on the frontend.

---

# 21. Security and Complexity

GraphQL gives clients significant flexibility.

That flexibility can introduce new problems.

Investigate:

* Deeply nested queries
* Very large queries
* Expensive resolvers
* Excessive database operations
* Introspection exposure
* Query complexity
* Query depth
* Rate limiting

Consider how an unrestricted client could construct an unnecessarily expensive query.

You do not need to implement every possible GraphQL security mechanism.

Understand the risks and introduce protections appropriate to this project.

---

# 22. Caching

Compare caching behavior between REST and GraphQL.

Consider:

```text id="v8m4k2"
REST
GET /devices/123
```

versus:

```text id="q5x7p9"
GraphQL
query {
    device(id: "123") {
        hostname
    }
}
```

Investigate why HTTP caching can be more straightforward with conventional REST GET requests and why GraphQL often requires different caching strategies.

Relate this to the Redis work from Stage 3.

---

# 23. Testing

Add automated tests for GraphQL.

Test:

### Queries

* List devices
* Retrieve device
* Retrieve nested services
* Retrieve events
* Retrieve scans

### Mutations

* Start scan
* Other state-changing operations

### Validation

Test:

* Invalid IDs
* Invalid arguments
* Missing required inputs
* Invalid input types

### Authentication

Test:

* Unauthenticated request
* Authenticated request

### Authorization

Test:

* Permitted operation
* Forbidden operation

### Errors

Test resolver and persistence failures.

---

# 24. REST vs GraphQL Experiment

Choose several frontend operations and implement them using both APIs.

For example:

```text id="n7x5c2"
Device Detail
```

Implement the same feature using:

```text id="x3m8q1"
REST
```

and:

```text id="w6k4p9"
GraphQL
```

Compare:

* Frontend code
* Number of HTTP requests
* Response sizes
* Backend implementation
* Database queries
* Error handling
* Caching
* Flexibility

Record your conclusions in:

```text id="q9m5k2"
docs/rest-vs-graphql.md
```

Do not decide that one technology "wins."

Determine where each approach is advantageous.

---

# 25. Milestones

## Milestone 1 — GraphQL Server

Run a GraphQL endpoint alongside the REST API.

---

## Milestone 2 — Schema

Define the initial GraphQL types and schema.

---

## Milestone 3 — Queries

Expose read operations.

---

## Milestone 4 — Resolvers

Connect GraphQL operations to existing application logic.

---

## Milestone 5 — Mutations

Expose selected state-changing operations.

---

## Milestone 6 — Nested Queries

Allow clients to request related data.

---

## Milestone 7 — Performance

Investigate and address N+1 queries and inefficient resolution.

---

## Milestone 8 — Authentication

Integrate the existing JWT authentication system.

---

## Milestone 9 — Authorization

Apply existing permissions to GraphQL operations.

---

## Milestone 10 — Frontend

Use GraphQL for selected frontend features.

---

## Milestone 11 — Security

Investigate query complexity, depth, and resource consumption.

---

## Milestone 12 — Comparison

Implement equivalent functionality through REST and GraphQL and document the differences.

---

# Completion Criteria

Stage 8 is complete when:

* A GraphQL endpoint runs alongside the REST API.
* The GraphQL schema represents the relevant Network Observatory domain.
* Queries can retrieve devices, services, scans, and events.
* Mutations can perform appropriate state-changing operations.
* Nested data can be requested.
* Resolvers reuse existing application logic.
* Authentication works with GraphQL.
* Authorization is enforced by the server.
* GraphQL validation errors are handled appropriately.
* Resolver failures do not expose internal implementation details.
* N+1 query behavior has been investigated and addressed where necessary.
* GraphQL can be used by the frontend for selected features.
* GraphQL introspection has been explored.
* GraphQL query complexity/security considerations have been investigated.
* REST and GraphQL implementations have been compared.
* Automated tests cover important GraphQL behavior.

You should be able to explain:

* What GraphQL is.
* Why GraphQL was created.
* The difference between REST and GraphQL.
* What a GraphQL schema represents.
* What a type is.
* What a query is.
* What a mutation is.
* What a resolver does.
* What GraphQL arguments and variables are.
* How nested queries work.
* What the N+1 problem is.
* How batching addresses N+1 queries.
* How authentication and authorization work with GraphQL.
* How GraphQL errors differ from typical REST errors.
* What introspection is.
* Why unrestricted GraphQL queries can become expensive.
* How GraphQL affects caching.
* When REST may be preferable to GraphQL.
* When GraphQL may be preferable to REST.

---

# Result

Network Observatory now exposes two API paradigms over the same application:

```text id="h4q7m2"
                         Clients
                            │
                 ┌──────────┴──────────┐
                 │                     │
                 ▼                     ▼
              REST API            GraphQL API
                 │                     │
                 └──────────┬──────────┘
                            ▼
                    Application Logic
                            │
                            ▼
                    Persistence Layer
                            │
             ┌──────────────┼──────────────┐
             ▼              ▼              ▼
        PostgreSQL       MongoDB         Redis
```

The important architectural principle is that **REST and GraphQL are interfaces to the same application, not two separate implementations of the application**.

You can now directly compare the two approaches using a real system you built yourself, rather than learning GraphQL in isolation.
