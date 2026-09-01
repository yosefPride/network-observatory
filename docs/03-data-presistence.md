# 03 — Data Persistence

## Purpose

Give Network Observatory persistent state.

In Stage 2, the discovery engine produces information and then forgets it when the process ends.

In this stage, the system should begin remembering:

* Devices
* Network interfaces
* Services
* Scans
* Discovery events
* Availability observations

The stage introduces three different data-storage technologies:

* PostgreSQL
* MongoDB
* Redis

The objective is not to use three databases simply because they are on the technology list.

The objective is to understand **different data-storage models and the problems they solve**.

---

# Objectives

By the end of this stage, understand and implement:

* Relational data modeling
* SQL
* PostgreSQL
* Primary keys
* Foreign keys
* Constraints
* Indexes
* Relationships
* Normalization
* Transactions
* Aggregation
* Query optimization
* MongoDB documents
* MongoDB collections
* Redis
* Caching
* Expiration
* Data persistence vs temporary state
* Database access from Python

---

# 1. Identify What Needs to Persist

Start with the output of Stage 2.

A scan currently produces information about:

```text
Scan
├── Network
├── Devices
│   ├── IP
│   ├── MAC
│   └── Hostname
└── Services
    ├── Port
    ├── Protocol
    └── State
```

Now ask:

> What information should Network Observatory remember after the scan finishes?

Separate information into categories.

For example:

```text
Current state
Historical events
Raw observations
Temporary state
```

Do not design the database yet.

First determine what the application actually needs to remember.

---

# 2. Data Modeling

Design the application's initial domain model.

Potential entities include:

```text
Device
NetworkInterface
Service
Scan
DiscoveryEvent
AvailabilityEvent
```

Determine:

* What each entity represents
* Which attributes belong to it
* Which entities are related
* Which values should be unique
* Which values may be missing
* Which information changes over time

Create:

```text
docs/data-model.md
```

Document your initial design before implementing it.

The design is expected to change.

---

# 3. SQL Fundamentals

Work directly with SQL before hiding database operations behind Python.

Learn:

### Data definition

```text
CREATE
ALTER
DROP
```

### Data manipulation

```text
INSERT
UPDATE
DELETE
```

### Queries

```text
SELECT
WHERE
ORDER BY
GROUP BY
HAVING
LIMIT
```

### Relationships

```text
JOIN
INNER JOIN
LEFT JOIN
```

### Database concepts

* Primary keys
* Foreign keys
* Unique constraints
* NOT NULL
* CHECK constraints
* Transactions
* Indexes

Write queries manually.

Do not rely entirely on an ORM or database abstraction.

---

# 4. PostgreSQL

Use PostgreSQL as the primary relational database for Network Observatory.

Create an initial schema based on your data model.

The exact schema is your responsibility.

The database should eventually represent concepts such as:

```text
Devices
   │
   ├── Network interfaces
   │
   └── Services
        │
        └── Observations
```

and:

```text
Scans
   │
   └── Discovery events
```

---

# 5. Database Constraints

Use the database itself to enforce invariants.

Consider questions such as:

* Can two devices have the same identifier?
* Can a service exist without a device?
* Can an event reference a nonexistent device?
* Can a port have an invalid value?
* Can required fields be NULL?
* What happens when a referenced device is deleted?

Do not rely entirely on Python validation.

Application-level validation and database-level constraints solve different problems.

---

# 6. Indexes

Once the database contains data, identify queries that need to be efficient.

Potential queries include:

```text
Find a device by IP
Find a device by MAC
Find all services belonging to a device
Find recent events
Find devices discovered during a scan
Find availability events for a device
```

For each index, understand:

> What query is this index improving?

Avoid creating indexes simply because indexes are "good."

---

# 7. Historical Data

Network Observatory needs to distinguish between:

```text
What is true now?
```

and:

```text
What did we observe previously?
```

For example, suppose a device is discovered today:

```text
192.168.1.20
```

Tomorrow it is no longer reachable.

You should not simply delete the device.

The system should be able to represent the historical observation:

```text
Device discovered
        ↓
Device available
        ↓
Device unavailable
```

This is the foundation for later monitoring and uptime history.

---

# 8. Persistence Integration

Connect the Python discovery engine to PostgreSQL.

The data flow should become:

```text
Network
   ↓
Discovery Engine
   ↓
Python objects
   ↓
Persistence layer
   ↓
PostgreSQL
```

Run multiple scans.

Verify that information survives:

```text
scanner exits
       ↓
scanner starts again
       ↓
previous information still exists
```

The application should begin recognizing previously observed devices rather than treating every scan as a completely new network.

---

# 9. Transactions

Introduce transactions where multiple database operations must succeed or fail together.

For example:

```text
Start scan
    ↓
record scan
    ↓
record observations
    ↓
record events
    ↓
complete scan
```

Consider what should happen if the process crashes halfway through.

Learn:

* Atomicity
* Commit
* Rollback
* Transaction boundaries

You should be able to explain why a transaction exists at each place you use one.

---

# 10. MongoDB

Introduce MongoDB after the PostgreSQL implementation is working.

The purpose is to explore a document-oriented database rather than replace PostgreSQL.

Store information that benefits from a flexible document structure.

Possible candidates include:

```text
Raw scan results
Raw device observations
Raw service observations
Diagnostic information
```

For example, a scan result could naturally be represented as one document containing nested observations.

Experiment with:

* Documents
* Collections
* Embedded documents
* Arrays
* Queries
* Updates
* Indexes

---

# 11. PostgreSQL vs MongoDB

Store some conceptually similar information in both systems and compare them.

Investigate:

### PostgreSQL

Best suited to:

* Structured relationships
* Constraints
* Referential integrity
* Relational queries
* Consistent application state

### MongoDB

Useful for:

* Flexible document structures
* Nested data
* Raw observations
* Data whose structure may evolve

Do not assume one database is universally better.

The goal is to understand the tradeoffs.

---

# 12. Redis

Introduce Redis for data that does not need to be the application's permanent source of truth.

Start with caching.

For example:

```text
GET device status
       ↓
Redis
   ├── cached → return
   │
   └── missing
         ↓
     PostgreSQL
         ↓
       Redis
```

Learn:

* Keys
* Values
* TTL
* Expiration
* Cache hits
* Cache misses
* Cache invalidation

---

# 13. Cache Design

Identify information that is appropriate to cache.

Possible candidates:

```text
Current device status
Recent scan status
Frequently requested device information
Network summary
```

For each cached value, answer:

> What happens if Redis loses this value?

The answer should generally be:

> The application can reconstruct it from persistent data.

Redis should not accidentally become the only copy of important information.

---

# 14. Python Database Layer

Organize database access so that the discovery engine does not need to know the details of PostgreSQL, MongoDB, or Redis.

Conceptually:

```text
Discovery Engine
       ↓
Application / Persistence Interface
       ↓
 ┌─────┼────────┐
 ▼     ▼        ▼
SQL  MongoDB   Redis
```

The exact module structure is intentionally left open.

Do not create a complicated repository/service architecture just because it appears in an example project.

Introduce abstractions when they solve an actual problem.

---

# 15. Database Initialization

Create a repeatable way to initialize the development database.

It should eventually be possible to:

```text
create database
       ↓
create schema
       ↓
create indexes
       ↓
start application
```

Investigate database migrations as part of this process.

The database should not depend on manually executing undocumented SQL every time the project is installed.

---

# 16. Testing

Add tests around persistence.

Test cases should include:

### Devices

* Create device
* Retrieve device
* Update device
* Find existing device
* Handle duplicate device

### Services

* Create service
* Associate service with device
* Retrieve services
* Handle invalid device

### Events

* Record discovery event
* Retrieve historical events
* Query events by device
* Query events by time

### Transactions

Test what happens when part of a multi-step operation fails.

### Redis

Test:

* Cache hit
* Cache miss
* Expiration
* Rebuilding a cached value

---

# 17. Data Integrity

Deliberately attempt to break your own database.

Try:

* Duplicate identifiers
* Invalid foreign keys
* Missing required values
* Invalid ports
* Deleting referenced records
* Interrupted transactions
* Corrupted or unexpected MongoDB documents

Determine which failures should be prevented by:

```text
Application
```

and which should be prevented by:

```text
Database
```

This distinction is important.

---

# 18. Milestones

## Milestone 1 — Data Model

Define the application's persistent entities and relationships.

---

## Milestone 2 — PostgreSQL

Create the relational schema and manually experiment with SQL.

---

## Milestone 3 — Persistence

Connect the discovery engine to PostgreSQL.

---

## Milestone 4 — Historical State

Record discoveries and changes over time.

---

## Milestone 5 — MongoDB

Introduce MongoDB for flexible/raw observation data.

---

## Milestone 6 — Redis

Introduce Redis for temporary or cached state.

---

## Milestone 7 — Python Integration

Create clean interfaces between the application and its persistence mechanisms.

---

## Milestone 8 — Reliability

Add transactions, constraints, indexes, error handling, and tests.

---

# Completion Criteria

Stage 3 is complete when:

* Network observations survive application restarts.
* Devices can be identified across multiple scans.
* Historical observations can be queried.
* Services are associated with devices.
* PostgreSQL is the primary source of structured persistent state.
* MongoDB is being used for an intentionally chosen document-oriented use case.
* Redis is being used for intentionally chosen temporary/cached state.
* Database constraints protect important invariants.
* Important queries have appropriate indexes.
* Multi-step database operations use appropriate transactions.
* Database failures are handled without silently corrupting application state.
* Persistence operations are covered by automated tests.

You should be able to explain:

* Why a particular piece of data belongs in PostgreSQL.
* Why a particular piece belongs in MongoDB.
* Why a particular piece belongs in Redis.
* The difference between persistent state and cached state.
* What a primary key is.
* What a foreign key is.
* Why indexes improve some queries.
* What a transaction guarantees.
* What normalization accomplishes.
* The difference between a relational database and a document database.
* What happens when Redis loses its data.

---

# Result

The system should now look conceptually like:

```text
                    Network
                       │
                       ▼
              Discovery Engine
                       │
                       ▼
                Structured Data
                       │
            ┌──────────┼──────────┐
            ▼          ▼          ▼
       PostgreSQL   MongoDB     Redis
       persistent     raw       temporary/
        state       data        cached data
```

The application now has memory.

A scan performed today can be compared with scans performed previously, devices can be tracked over time, and the data is ready to be exposed through the API in the next stage.
