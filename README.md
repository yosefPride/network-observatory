# Network Observatory

A local-network discovery and monitoring platform built from scratch as a learning project.

The purpose of this project is not simply to produce a working application. It is to learn how the individual technologies fit together by using them to solve progressively more complex problems.

## Goals

The system will eventually be able to:

* Discover devices on a local network
* Identify and track devices over time
* Discover services running on devices
* Monitor device and service availability
* Record historical network events
* Display network state through a web interface
* Expose both REST and GraphQL APIs
* Authenticate users
* Store and query historical data
* Run locally using Docker
* Deploy to Kubernetes
* Operate remotely on Linux

The project is intentionally built in stages. Each stage introduces a new technical problem and the technologies needed to solve it.

---

# Development Stages

## Stage 1 — Foundations

Set up the development environment and establish the project's basic structure.

**Focus:**

* Linux
* Linux filesystem
* Bash
* Regex
* Git

**Technical plan:** [01-foundations.md](docs/01-foundations.md)

---

## Stage 2 — Network Discovery

Build the first useful version of the application: a command-line tool capable of discovering devices on the local network.

**Focus:**

* Python
* Networking fundamentals
* Network discovery
* Concurrency
* CLI design

**Technical plan:** [02-network-discovery.md](docs/02-network-discovery.md)

---

## Stage 3 — Data Persistence

Make discoveries persistent and begin building the application's data model.

**Focus:**

* SQL
* PostgreSQL
* MongoDB
* Redis
* Data modeling

**Technical plan:** [03-data-persistence.md](docs/03-data-persistence.md)

---

## Stage 4 — API

Expose the network-observation system through a web API.

**Focus:**

* FastAPI
* Pydantic
* REST
* HTTP
* OpenAPI
* Postman

**Technical plan:** [04-api.md](docs/04-api.md)

---

## Stage 5 — Authentication

Introduce users and secure the API.

**Focus:**

* Authentication
* Authorization
* JWT
* Password handling
* API security

**Technical plan:** [05-authentication.md](docs/05-authentication.md)

---

## Stage 6 — Web Interface

Build a browser-based interface for viewing and interacting with the network.

**Focus:**

* HTML
* CSS
* JavaScript
* DOM
* Browser ↔ API communication

**Technical plan:** [06-frontend.md](docs/06-frontend.md)

---

## Stage 7 — Monitoring

Transform the discovery tool into a monitoring system.

**Focus:**

* Periodic discovery
* Availability monitoring
* Service monitoring
* Historical events
* Logging
* Real-time updates

**Technical plan:** [07-monitoring.md](docs/07-monitoring.md)

---

## Stage 8 — GraphQL

Add GraphQL as a second API interface and compare it with the existing REST API.

**Focus:**

* GraphQL schema
* Queries
* Mutations
* Resolvers
* REST vs GraphQL

**Technical plan:** [08-graphql.md](docs/08-graphql.md)

---

## Stage 9 — Containerization

Package the application and its dependencies into a reproducible environment.

**Focus:**

* Docker
* Images
* Containers
* Dockerfiles
* Docker daemon
* Docker Compose
* YAML

**Technical plan:** [09-containerization.md](docs/09-containerization.md)

---

## Stage 10 — Kubernetes

Deploy the application as a Kubernetes workload.

**Focus:**

* Kubernetes
* Pods
* Deployments
* Services
* Configuration
* Secrets
* Persistent storage
* Networking
* YAML

**Technical plan:** [10-kubernetes.md](docs/10-kubernetes.md)

---

## Stage 11 — Remote Deployment

Operate the system on a remote Linux machine.

**Focus:**

* SSH
* mobaX
* Linux administration
* GitLab
* CI/CD
* Deployment
* Production troubleshooting

**Technical plan:** [11-deployment.md](docs/11-deployment.md)

---

# Technology Map

The technologies are introduced as the project requires them rather than being studied independently.

| Technology | Main Stage |
| ---------- | ---------- |
| Linux      | 1          |
| Bash       | 1          |
| Regex      | 1–2        |
| Git        | 1          |
| Python     | 2          |
| SQL        | 3          |
| PostgreSQL | 3          |
| MongoDB    | 3          |
| Redis      | 3          |
| FastAPI    | 4          |
| Pydantic   | 4          |
| Postman    | 4          |
| OpenAPI    | 4          |
| JWT        | 5          |
| HTML       | 6          |
| CSS        | 6          |
| JavaScript | 6          |
| DOM        | 6          |
| GraphQL    | 8          |
| Logging    | 7          |
| Docker     | 9          |
| YAML       | 9–10       |
| Kubernetes | 10         |
| mobaX      | 11         |
| GitLab     | 11         |
| GitKraken  | Throughout |

---

# Development Principles

## Build before reading too much

Each stage should begin with a concrete problem.

Learn enough theory to understand the problem, attempt the implementation yourself, and use documentation and AI assistance when needed.

## AI is a learning aid

AI may be used for:

* Explaining concepts
* Answering questions
* Reviewing code
* Debugging
* Critiquing designs
* Explaining documentation
* Suggesting tests

The implementation should primarily be written by the developer.

When possible, attempt a solution before asking AI for one.

## Don't introduce technologies prematurely

A technology should be introduced when the current system creates a reason to use it.

For example, don't add Redis simply because Redis is on the learning list. First encounter a problem that caching, temporary state, or queuing can reasonably solve.

## Understand every component

At each stage, be able to explain:

* What problem does this component solve?
* Why is it needed?
* What alternatives exist?
* How does it communicate with the rest of the system?
* What happens when it fails?

---

# Completion

The project is considered complete when the system can:

1. Discover devices on a network
2. Persist observations
3. Discover and monitor services
4. Track historical availability
5. Expose the system through REST and GraphQL
6. Authenticate users
7. Provide a functional web interface
8. Log important events
9. Run as a Dockerized application
10. Deploy to Kubernetes
11. Be operated remotely on Linux
12. Be built and deployed through a GitLab workflow

The individual stage documents contain the technical requirements and implementation details.

