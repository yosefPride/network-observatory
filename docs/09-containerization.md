# 09 — Kubernetes

## Purpose

Deploy Network Observatory to Kubernetes.

Docker introduced containerization earlier in the project.

Kubernetes introduces orchestration: managing containers as a system rather than running individual containers manually.

This stage should take the application that already works locally and make it run as a Kubernetes workload.

The emphasis is on understanding Kubernetes concepts by applying them to a real application.

---

# Objectives

By the end of this stage, understand and implement:

* Kubernetes
* Clusters
* Nodes
* Pods
* Deployments
* Services
* Namespaces
* ConfigMaps
* Secrets
* Volumes
* Persistent storage
* Environment variables
* Health probes
* Resource requests and limits
* Scaling
* Rolling updates
* Networking
* Service discovery
* Ingress
* Kubernetes configuration files
* `kubectl`
* Container orchestration

---

# 1. Why Kubernetes?

Start by identifying the problem Kubernetes solves.

Without Kubernetes:

```text
Docker
 ├── Start container
 ├── Stop container
 ├── Restart container
 ├── Configure networking
 └── Manage multiple containers manually
```

With Kubernetes:

```text
Kubernetes
 ├── Schedule containers
 ├── Restart failed workloads
 ├── Provide networking
 ├── Manage configuration
 ├── Manage storage
 ├── Scale workloads
 └── Perform controlled updates
```

The objective is to understand the problems Kubernetes is designed to solve rather than simply learning Kubernetes syntax.

---

# 2. Kubernetes Architecture

Learn the basic architecture of a Kubernetes cluster.

Understand:

```text
Cluster
│
├── Control Plane
│
└── Nodes
    │
    ├── Pod
    ├── Pod
    └── Pod
```

Learn the responsibilities of the major control-plane components at a conceptual level.

Understand that Kubernetes is itself a distributed system.

---

# 3. kubectl

Learn the Kubernetes command-line interface.

Use `kubectl` to:

* Inspect the cluster
* Create resources
* Apply configuration
* Inspect workloads
* View logs
* Execute commands
* Delete resources
* Inspect events

Become comfortable answering questions such as:

```text
What is running?

Where is it running?

Why isn't it running?

What happened to this pod?

What services exist?

What configuration is being used?
```

---

# 4. Local Kubernetes Cluster

Set up a local Kubernetes environment.

Choose an appropriate local cluster solution.

Possible options include:

* Minikube
* Kind
* K3d
* Docker Desktop Kubernetes

Choose one rather than trying to learn all of them.

The cluster should be capable of running Network Observatory locally.

---

# 5. Namespaces

Create an appropriate namespace for the application.

For example:

```text
network-observatory
```

Understand why namespaces exist and how they can provide logical isolation within a cluster.

Use the namespace consistently throughout this stage.

---

# 6. Pods

Deploy the application as a Kubernetes Pod.

Understand that a Pod is Kubernetes' basic unit of deployment rather than treating a Pod as simply another name for a container.

Learn:

* Pod lifecycle
* Container status
* Pod IPs
* Restart behavior
* Logs
* Multiple containers within a Pod

Do not assume that every container should have its own Pod or that multiple application components automatically belong in one Pod.

---

# 7. Deployments

Use a Deployment to manage the application.

Understand what a Deployment provides:

```text
Deployment
    ↓
ReplicaSet
    ↓
Pods
```

The Deployment should control the desired number of application replicas.

Experiment with:

```text
1 replica
```

and:

```text
2+ replicas
```

Observe what Kubernetes does when a Pod is deleted.

---

# 8. Services

Pods are ephemeral.

Their IP addresses should not be treated as permanent application addresses.

Create Kubernetes Services to provide stable network access to workloads.

Understand:

```text
Client
  ↓
Service
  ↓
Pod
```

Learn about appropriate Service types.

For the initial deployment, determine which type is appropriate for:

```text
frontend/API access
internal services
database access
```

---

# 9. Kubernetes Networking

Understand how workloads communicate inside the cluster.

Explore:

```text
Pod → Pod
Pod → Service
Pod → Database
Browser → Application
```

Learn about Kubernetes DNS and service discovery.

The application should communicate with services by Kubernetes service names rather than hard-coded Pod IP addresses.

---

# 10. Application Architecture in Kubernetes

Translate the existing application architecture into Kubernetes workloads.

A possible conceptual structure is:

```text
                    Browser
                       │
                       ▼
                    Ingress
                       │
                       ▼
                  Frontend/API
                       │
          ┌────────────┼────────────┐
          ▼            ▼            ▼
      PostgreSQL     MongoDB       Redis
```

The exact deployment structure is your decision.

Do not automatically create a Kubernetes resource for every software component.

Understand which components are appropriate to run inside the cluster and which may remain external.

---

# 11. Configuration

Move application configuration into Kubernetes configuration resources where appropriate.

Learn about:

* ConfigMaps
* Environment variables
* Secrets

Separate:

```text
application configuration
```

from:

```text
sensitive credentials
```

Do not commit real credentials into Kubernetes manifests.

---

# 12. Secrets

Use Kubernetes Secrets for sensitive configuration.

Potential examples:

```text
Database credentials
JWT signing key
API credentials
```

Understand what Kubernetes Secrets actually provide.

Do not assume that putting a value in a Kubernetes Secret automatically makes it cryptographically secure in every context.

---

# 13. Persistent Storage

Some components require data to survive Pod replacement.

Understand the difference between:

```text
Pod filesystem
```

and:

```text
Persistent storage
```

Learn:

* Volumes
* PersistentVolumes
* PersistentVolumeClaims
* StorageClasses

Determine which Network Observatory components require persistent storage.

For example:

```text
PostgreSQL
MongoDB
```

may need persistent storage depending on the deployment architecture.

---

# 14. Databases in Kubernetes

Decide how the project's databases should be handled.

Possible approaches include:

```text
Application in Kubernetes
Database outside Kubernetes
```

or:

```text
Application in Kubernetes
Database in Kubernetes
```

Evaluate the tradeoffs.

If you deploy databases inside Kubernetes for learning purposes, understand that running a database in Kubernetes introduces additional operational concerns.

Do not confuse:

```text
"possible to run in Kubernetes"
```

with:

```text
"best production architecture"
```

---

# 15. Health Probes

Use Kubernetes health probes.

Understand:

### Liveness

Is the application still alive?

### Readiness

Is the application ready to receive traffic?

### Startup

Has the application finished starting?

Configure appropriate probes for the API.

Relate these probes to the health endpoints created in Stage 7.

---

# 16. Resource Requests and Limits

Introduce resource management.

Learn the difference between:

```text
requests
```

and:

```text
limits
```

Determine reasonable initial values for:

```text
CPU
Memory
```

for Network Observatory components.

Observe what happens when workloads approach their configured limits.

---

# 17. Scaling

Scale the application.

For example:

```text
1 API replica
      ↓
2 API replicas
      ↓
3 API replicas
```

Determine what changes when multiple instances are running.

Pay particular attention to application state.

Ask:

> Can any API replica handle any request?

If not, determine why.

This should reinforce the stateless/statful distinction.

---

# 18. Monitoring Worker

Network Observatory contains monitoring work that runs independently of HTTP requests.

Determine how that component should behave when multiple API replicas exist.

For example:

```text
API Pod 1
API Pod 2
API Pod 3
```

should not accidentally result in:

```text
three independent monitoring loops
```

all performing the same scan.

Design the Kubernetes deployment so monitoring work has an appropriate execution model.

This is an important architectural problem rather than merely a Kubernetes configuration exercise.

---

# 19. Ingress

Introduce an Ingress mechanism.

Conceptually:

```text
Internet / Browser
       │
       ▼
    Ingress
       │
       ▼
   Kubernetes
    Service
       │
       ▼
      Pods
```

Learn:

* Host-based routing
* Path-based routing
* TLS termination
* Ingress controllers

Determine which ingress controller is appropriate for your local environment.

---

# 20. Frontend and API Routing

Determine how the browser should reach the frontend and API.

For example:

```text
example.local/
```

could serve the frontend while:

```text
example.local/api/
```

routes to FastAPI.

Alternatively, use separate hosts.

The important objective is to understand how Kubernetes networking exposes multiple application components.

---

# 21. Rolling Updates

Modify the application and deploy a new version.

Observe a Deployment performing a rolling update.

Understand:

```text
Version 1
   ↓
New Pods created
   ↓
New Pods become ready
   ↓
Old Pods removed
```

Investigate what happens when the new version fails its readiness check.

The deployment should not blindly route traffic to an unhealthy application.

---

# 22. Rollbacks

Deliberately deploy a broken version.

Learn how to:

* Inspect deployment history
* Identify the previous version
* Roll back
* Verify recovery

This demonstrates why Kubernetes deployments maintain rollout history.

---

# 23. Logs

Use Kubernetes tooling to inspect application logs.

Understand the relationship between:

```text
Application logs
```

and:

```text
Kubernetes logs
```

Use `kubectl` to inspect:

* Current logs
* Previous container logs
* Logs from specific Pods

Relate this to the structured logging work from Stage 7.

---

# 24. Kubernetes Events

Learn to inspect Kubernetes events.

Events can help explain situations such as:

```text
Pod could not start
Image could not be pulled
Volume could not mount
Probe failed
Container restarted
```

Learn to distinguish:

```text
application logs
```

from:

```text
Kubernetes events
```

Both provide different kinds of operational information.

---

# 25. YAML

Use Kubernetes YAML manifests extensively.

Learn:

* YAML structure
* Kubernetes resource manifests
* Metadata
* Labels
* Selectors
* Spec
* Nested configuration
* Multi-document YAML

Avoid blindly copying manifests.

You should be able to explain what each important field does.

---

# 26. Labels and Selectors

Understand how Kubernetes identifies relationships between resources.

For example:

```text
Deployment
    │
    │ selector
    ▼
Pods
```

and:

```text
Service
    │
    │ selector
    ▼
Pods
```

Learn why mismatched labels and selectors can make an otherwise valid deployment appear broken.

---

# 27. Application Updates

Create a repeatable deployment process.

The process should resemble:

```text
Code
 ↓
Build
 ↓
Docker image
 ↓
Push/store image
 ↓
Update Kubernetes deployment
 ↓
Rollout
 ↓
Health checks
 ↓
Running application
```

The exact image registry and deployment mechanism can remain local for now.

---

# 28. Security

Perform a basic Kubernetes security review.

Consider:

* Container privileges
* Running as root
* Secret exposure
* Network access
* Service exposure
* Image provenance
* Resource limits
* Namespace isolation

Do not attempt to implement a complete Kubernetes security architecture.

The goal is to understand the major attack surfaces introduced by container orchestration.

---

# 29. Troubleshooting Exercises

Deliberately break the deployment.

Examples:

```text
Wrong image
Wrong environment variable
Wrong Service selector
Invalid Secret
Invalid ConfigMap
Broken health probe
Incorrect port
Missing volume
Insufficient resources
```

For each failure, diagnose the problem using Kubernetes tools.

The goal is to become comfortable debugging a cluster rather than only deploying a working YAML file.

---

# 30. Testing

Verify the Kubernetes deployment as a system.

Test:

### Application

* Frontend loads
* API responds
* Authentication works
* GraphQL works

### Networking

* Frontend can reach API
* API can reach dependencies
* External traffic reaches the application

### Persistence

* Data survives Pod replacement

### Scaling

* Multiple API replicas work correctly

### Monitoring

* Monitoring continues correctly

### Recovery

* Failed Pods are replaced
* Unhealthy Pods stop receiving traffic

### Deployment

* Updates roll out
* Failed updates can be rolled back

---

# 31. Milestones

## Milestone 1 — Cluster

Create and understand a local Kubernetes cluster.

---

## Milestone 2 — Application Pod

Run the application inside Kubernetes.

---

## Milestone 3 — Deployment

Manage the application through a Deployment.

---

## Milestone 4 — Services

Create stable internal networking.

---

## Milestone 5 — Configuration

Introduce ConfigMaps and Secrets.

---

## Milestone 6 — Persistence

Configure persistent storage where necessary.

---

## Milestone 7 — Health

Connect Kubernetes health probes to the application's health endpoints.

---

## Milestone 8 — Scaling

Run multiple application replicas.

---

## Milestone 9 — Monitoring Worker

Ensure monitoring work behaves correctly in a multi-replica environment.

---

## Milestone 10 — Ingress

Expose the application through an Ingress.

---

## Milestone 11 — Updates

Perform rolling updates and rollbacks.

---

## Milestone 12 — Troubleshooting

Break the deployment intentionally and diagnose the failures.

---

# Completion Criteria

Stage 9 is complete when:

* A local Kubernetes cluster is operational.
* Network Observatory runs inside Kubernetes.
* The application is managed through Deployments.
* Kubernetes Services provide stable networking.
* Pods communicate through Kubernetes networking and DNS.
* Configuration is separated from application images.
* Sensitive configuration uses Kubernetes Secrets.
* Required application data survives Pod replacement.
* Health probes are configured.
* Resource requests and limits are defined.
* The application can run multiple API replicas.
* Monitoring work does not accidentally duplicate itself because of API scaling.
* The application is externally accessible through an Ingress or appropriate local equivalent.
* Rolling updates work.
* Rollbacks work.
* Kubernetes logs and events can be inspected.
* Common deployment failures can be diagnosed using Kubernetes tooling.
* The complete application can be tested as a Kubernetes deployment.

You should be able to explain:

* What Kubernetes solves.
* What a cluster is.
* What the control plane does.
* What a node is.
* What a Pod is.
* Why Pods are considered ephemeral.
* What a Deployment does.
* What a ReplicaSet does.
* Why Services exist.
* How Kubernetes service discovery works.
* What Namespaces provide.
* The difference between ConfigMaps and Secrets.
* Why persistent storage is necessary.
* The difference between liveness, readiness, and startup probes.
* The difference between resource requests and limits.
* How Kubernetes performs rolling updates.
* How rollbacks work.
* What an Ingress does.
* How labels and selectors connect Kubernetes resources.
* How to diagnose a failed Pod.
* Why scaling a stateless API is different from scaling a stateful component.
* Why a background worker can become problematic when an application is replicated.

---

# Result

Network Observatory now runs as an orchestrated containerized application:

```text
                         Kubernetes Cluster
                                │
                 ┌──────────────┴──────────────┐
                 │                             │
              Ingress                       Services
                 │                             │
                 ▼                             ▼
             Frontend/API                 Dependencies
                 │                    ┌────────┼────────┐
          ┌──────┼──────┐             ▼        ▼        ▼
          ▼      ▼      ▼         PostgreSQL MongoDB  Redis
        Pod    Pod    Pod
          │
          └──────────────┐
                         ▼
                 Monitoring Worker
```

The application can now be:

* deployed,
* restarted,
* scaled,
* updated,
* rolled back,
* monitored,
* and recovered

through Kubernetes rather than manually managing individual Docker containers.

Most importantly, you should now understand **why Kubernetes resources exist and how they fit together**, rather than simply knowing how to write Kubernetes YAML.




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
