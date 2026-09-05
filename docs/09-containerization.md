# 09 — Containerization

## Purpose

Containerize Network Observatory using Docker.

The application should move from:

```text
source code
    ↓
run locally
```

to:

```text
source code
    ↓
Docker image
    ↓
Docker container
    ↓
running application
```

This stage focuses on understanding Docker itself rather than Kubernetes.

The goal is to understand what containers are, how Docker creates and runs them, how images are built, how containers communicate, and how a multi-component application can be run reproducibly.

---

# Objectives

By the end of this stage, understand and implement:

* Docker
* Images
* Containers
* Docker daemon
* Docker CLI
* Dockerfiles
* Image layers
* Build context
* `.dockerignore`
* Container networking
* Ports
* Environment variables
* Volumes
* Container lifecycle
* Multi-container applications
* Docker Compose
* Image tagging
* Container logs
* Container inspection
* Container health checks
* Container resource usage
* Reproducible builds

---

# 1. Why Containers?

Understand the problem containerization solves.

Without containerization:

```text id="4l9v6x"
Developer machine
├── Python version
├── Python packages
├── Database
├── Redis
└── System dependencies
```

Another machine may have different versions and configuration.

Containers provide a controlled runtime environment:

```text id="8s4z5w"
Docker Image
    ↓
Container
    ↓
Application
```

The objective is to understand what Docker actually isolates and what it does not.

---

# 2. Docker Architecture

Understand the major components of Docker.

Conceptually:

```text id="q3y8w1"
Docker CLI
    │
    ▼
Docker daemon
    │
    ├── Images
    ├── Containers
    ├── Networks
    └── Volumes
```

Understand the relationship between:

* Docker client
* Docker daemon
* Docker Engine
* Docker images
* Docker containers
* Docker registries

You should be able to explain what happens when you execute a command such as:

```text
docker run ...
```

---

# 3. Docker Images

Learn what a Docker image is.

Understand that an image contains the filesystem and configuration needed to create a container.

Investigate:

* Image layers
* Image metadata
* Base images
* Image tags
* Image IDs
* Image size

Understand the distinction between:

```text id="x7w3k9"
Image
```

and:

```text id="p8m2v4"
Container
```

An image is a template.

A container is a running instance created from that image.

---

# 4. Docker Containers

Learn the container lifecycle.

Understand:

```text id="a8q4r7"
created
   ↓
running
   ↓
stopped
   ↓
removed
```

Experiment with:

* Starting containers
* Stopping containers
* Restarting containers
* Removing containers
* Inspecting containers
* Executing commands inside containers

Understand what happens to the container's writable filesystem when the container is removed.

---

# 5. Dockerfile

Create a Dockerfile for the Network Observatory application.

Learn the purpose of instructions such as:

```text id="9k4m7p"
FROM
WORKDIR
COPY
RUN
ENV
EXPOSE
CMD
ENTRYPOINT
```

Understand the difference between:

```text id="v5y3j8"
building an image
```

and:

```text id="d4q6s1"
running a container
```

---

# 6. Build Context

Understand Docker's build context.

Determine:

```text id="n7c2w5"
What files are available during a Docker build?
```

Learn why sending unnecessary files into the build context can be undesirable.

This leads into `.dockerignore`.

---

# 7. `.dockerignore`

Create an appropriate `.dockerignore`.

Exclude files that do not belong in the image.

Potential examples:

```text id="4p8z2q"
.git
__pycache__
.env
venv
node_modules
documentation
development artifacts
```

The exact contents should reflect the project's structure.

Understand that `.dockerignore` is about the Docker build context, not merely keeping the final image small.

---

# 8. Python Application Image

Create a production-oriented image for the FastAPI application.

The image should contain what is required to run the server but should not contain unnecessary development files.

The resulting flow should be:

```text id="8q4j7s"
Python source
     ↓
Docker build
     ↓
Network Observatory image
     ↓
Docker run
     ↓
FastAPI / Uvicorn
```

---

# 9. Dependencies

Determine how Python dependencies should be installed inside the image.

Understand:

* Dependency files
* Dependency versions
* Reproducible installation
* Build-time vs runtime dependencies

The container should not depend on packages installed on the host machine.

---

# 10. Ports

Understand the difference between:

```text id="1m8x3z"
container port
```

and:

```text id="7c4q9y"
host port
```

For example:

```text id="z3n7w5"
Host
localhost:8000
      │
      ▼
Container
:8000
      │
      ▼
Uvicorn
```

Learn what `EXPOSE` does and does not do.

---

# 11. Environment Variables

Move runtime configuration out of the image where appropriate.

For example:

```text id="k8q1p5"
DATABASE_URL
REDIS_URL
JWT_SECRET
API configuration
```

Understand the difference between:

```text id="2z8x4v"
build-time configuration
```

and:

```text id="7w6k1q"
runtime configuration
```

The same image should ideally be usable in different environments without rebuilding it merely because configuration changes.

---

# 12. Secrets

Review how sensitive values are handled.

Do not:

```text id="0m5v8c"
COPY .env .
```

or bake real credentials into the image.

Understand why secrets inside an image can remain recoverable even after the application stops using them.

Use appropriate runtime configuration mechanisms instead.

---

# 13. Container Networking

Run multiple containers and make them communicate.

Conceptually:

```text id="9q4r6x"
Frontend/API
      │
      ▼
PostgreSQL
```

and:

```text id="k6t2m8"
FastAPI
   ├── PostgreSQL
   ├── MongoDB
   └── Redis
```

Understand:

* Container IP addresses
* Docker networks
* Network isolation
* Container DNS
* Service names

Do not rely on manually discovered container IP addresses.

---

# 14. Database Containers

Determine how the project's databases should run during local development.

Potential containers:

```text id="h7j3q9"
PostgreSQL
MongoDB
Redis
```

The goal is to make the complete development environment reproducible.

For example:

```text id="z4m6w2"
Network Observatory
├── API
├── PostgreSQL
├── MongoDB
└── Redis
```

---

# 15. Volumes

Understand container persistence.

A container's writable filesystem should not be treated as permanent storage for important data.

Learn:

```text id="x9k5s3"
Container
    │
    ▼
Volume
    │
    ▼
Persistent data
```

Determine which components need persistent storage.

Test what happens when a database container is removed and recreated.

---

# 16. Docker Compose

Introduce Docker Compose for the multi-container application.

Create a Compose configuration representing the development environment.

Conceptually:

```text id="q6r8v2"
docker compose
      │
      ├── API
      ├── PostgreSQL
      ├── MongoDB
      └── Redis
```

Use Compose to:

* Create networks
* Start services
* Stop services
* Configure dependencies
* Configure environment variables
* Configure volumes
* Expose ports

The objective is to replace a collection of manual `docker run` commands with a reproducible environment definition.

---

# 17. Service Discovery

Use Compose service names for communication.

For example, the API should conceptually connect to:

```text id="p4w8n1"
postgres
mongo
redis
```

rather than:

```text id="r8q3x7"
localhost
```

Understand why `localhost` inside a container refers to that container itself.

This is one of the most important conceptual differences when moving applications into containers.

---

# 18. Container Lifecycle

Test the entire environment repeatedly.

For example:

```text id="6y2k9q"
docker compose up
      ↓
application running
      ↓
docker compose down
      ↓
environment stopped
      ↓
docker compose up
      ↓
environment restored
```

Determine which data survives:

```text id="9m3w7p"
container recreation
```

and which does not.

Volumes should be used where persistence is required.

---

# 19. Health Checks

Add container health checks where appropriate.

A health check should answer whether a service is functioning sufficiently for its intended purpose.

For example:

```text id="w4q8m5"
API
 ↓
/health
```

Understand the distinction between:

```text id="5c7z2x"
process is running
```

and:

```text id="3p6k8v"
application is healthy
```

---

# 20. Logs

Learn to inspect container logs.

Use Docker tooling to answer questions such as:

```text id="a3w7k5"
Did the application start?

Why did the container stop?

Did the database start?

Did the API connect to Redis?

What error occurred?
```

Relate Docker logs to the application logging system introduced earlier.

---

# 21. Container Inspection

Use Docker's inspection capabilities to investigate running containers.

Understand how to inspect:

* Environment
* Ports
* Networks
* Mounts
* Image
* Entrypoint
* Command
* State

You should be able to diagnose configuration problems without opening the Dockerfile every time.

---

# 22. Resource Usage

Observe container resource consumption.

Investigate:

```text id="q7m4s8"
CPU
Memory
Network
Disk
```

Understand that containerization does not eliminate resource consumption.

A poorly behaved application can still consume excessive host resources.

---

# 23. Image Optimization

Review the image you created.

Investigate:

* Image size
* Number of layers
* Base image choice
* Build cache
* Unnecessary files
* Build dependencies

Consider whether a multi-stage build is useful.

Do not optimize prematurely.

The goal is to understand why image size and layer structure matter.

---

# 24. Reproducibility

Destroy the local environment and recreate it.

The goal should be:

```text id="8v2m4n"
Fresh machine
    ↓
Clone repository
    ↓
Docker / Docker Compose
    ↓
Complete development environment
```

without manually installing the application's runtime dependencies on the host.

This is one of the major practical benefits of containerization.

---

# 25. Image Tagging

Learn how images are identified and versioned.

For example:

```text id="4m8x2q"
network-observatory:latest
network-observatory:0.1.0
network-observatory:dev
```

Understand why relying exclusively on:

```text id="n3q7w1"
latest
```

can create deployment ambiguity.

Use explicit tags when reproducibility matters.

---

# 26. Registry

Understand the role of a container registry.

Conceptually:

```text id="r7p4m2"
Local machine
     │
     ▼
Docker image
     │
     ▼
Container registry
     │
     ▼
Other machine
     │
     ▼
Container
```

You do not need to build a full deployment pipeline yet.

The objective is to understand how images move between environments.

---

# 27. Docker and Security

Perform a basic security review.

Consider:

* Running as root
* Image vulnerabilities
* Secrets
* Exposed ports
* Excessive permissions
* Untrusted base images
* Unnecessary packages

Investigate how the container can be made to run with fewer privileges.

Do not assume that containerization itself provides complete security isolation.

---

# 28. Troubleshooting Exercises

Deliberately introduce problems.

Examples:

```text id="9p6w3k"
Wrong port
Wrong environment variable
Missing dependency
Incorrect database hostname
Missing volume
Broken Dockerfile command
Wrong Compose service name
Container exits immediately
Database cannot be reached
```

Diagnose each problem using Docker tools.

Learn to distinguish:

```text id="f7x2k4"
build problems
```

from:

```text id="q9m3w6"
runtime problems
```

and:

```text id="v4k8z2"
networking problems
```

---

# 29. Testing

Verify the complete containerized application.

Test:

### Build

* Image builds successfully
* Build is reproducible
* Unnecessary files are excluded

### Runtime

* API starts
* Frontend is accessible
* Containers communicate

### Persistence

* Database data survives container recreation

### Networking

* API reaches all dependencies
* External requests reach the application

### Configuration

* Runtime configuration works
* Secrets are not baked into images

### Recovery

* Containers can be stopped and restarted
* Services recover appropriately

---

# 30. Milestones

## Milestone 1 — Docker Fundamentals

Learn the Docker CLI, daemon, images, and containers.

---

## Milestone 2 — Application Image

Create a Dockerfile for the application.

---

## Milestone 3 — Configuration

Move runtime configuration outside the image.

---

## Milestone 4 — Networking

Create container networks and connect application components.

---

## Milestone 5 — Persistence

Introduce Docker volumes for stateful services.

---

## Milestone 6 — Compose

Run the complete application using Docker Compose.

---

## Milestone 7 — Health

Add and test container health checks.

---

## Milestone 8 — Observability

Inspect logs, container state, and resource usage.

---

## Milestone 9 — Optimization

Review image structure, size, dependencies, and build process.

---

## Milestone 10 — Reproducibility

Destroy and recreate the entire environment successfully.

---

## Milestone 11 — Registry

Build, tag, and understand distribution of container images.

---

## Milestone 12 — Security

Review the containerized application for common security problems.

---

# Completion Criteria

Stage 9 is complete when:

* Network Observatory can be built as a Docker image.
* The image contains everything required to run the application.
* The application does not depend on host-installed Python packages.
* Runtime configuration is externalized.
* Secrets are not baked into images.
* Containers communicate through Docker networking.
* PostgreSQL, MongoDB, and Redis can be run as containerized dependencies where appropriate.
* Persistent data uses Docker volumes where required.
* Docker Compose can start the complete development environment.
* Services can communicate using container/service names.
* Container health checks are implemented where appropriate.
* Container logs can be inspected.
* Container configuration can be inspected.
* Resource consumption can be observed.
* The image has been reviewed for unnecessary contents.
* The complete environment can be destroyed and recreated.
* Images can be tagged and understood as versioned artifacts.
* Common Docker build, runtime, networking, and persistence problems can be diagnosed.
* Basic container security concerns have been reviewed.

You should be able to explain:

* What Docker is.
* What the Docker daemon does.
* What an image is.
* What a container is.
* The difference between an image and a container.
* What happens during `docker build`.
* What happens during `docker run`.
* What Dockerfile instructions do.
* What image layers are.
* What the build context is.
* Why `.dockerignore` exists.
* The difference between host ports and container ports.
* How containers communicate.
* Why `localhost` behaves differently inside a container.
* What Docker volumes provide.
* Why databases require persistent storage.
* What Docker Compose provides.
* How service discovery works in Compose.
* The difference between build-time and runtime configuration.
* Why secrets should not be baked into images.
* How to inspect and troubleshoot a container.
* How containerization relates to reproducibility.
* How Docker differs from a virtual machine.
* Why containerization does not automatically make an application secure.

---

# Result

Network Observatory can now be packaged as a reproducible containerized system:

```text id="6q9x3m"
                         Docker Compose
                              │
          ┌───────────────────┼───────────────────┐
          │                   │                   │
          ▼                   ▼                   ▼
        API               PostgreSQL           MongoDB
          │
          │
          ▼
        Redis
```

Each component runs in its own container while Docker provides:

```text id="k8m4q2"
Networking
Configuration
Process isolation
Storage
Logging
Lifecycle management
```

The important result is not merely that:

> "The application runs in Docker."

It is that you understand how to take an application, package it into images, run those images as containers, connect multiple containers, persist state, configure them, inspect them, troubleshoot them, and reproduce the environment.

This provides the foundation for the next stage: **Kubernetes**, where these containers can be orchestrated as a larger system.
