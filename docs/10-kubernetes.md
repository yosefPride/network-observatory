# 10 — Kubernetes

## Purpose

Deploy and manage the containerized Network Observatory application using Kubernetes.

Stage 9 established Docker and containerization.

This stage builds on that foundation by introducing container orchestration.

Instead of manually managing:

```text
Docker container
Docker container
Docker container
```

Kubernetes manages workloads as a system:

```text
Kubernetes
    │
    ├── API
    ├── PostgreSQL
    ├── MongoDB
    └── Redis
```

The objective is not to memorize Kubernetes YAML.

The objective is to understand **why Kubernetes exists, how its components fit together, and how Kubernetes manages containerized applications**.

---

# Objectives

By the end of this stage, understand and implement:

* Kubernetes
* Clusters
* Control plane
* Nodes
* Pods
* Deployments
* ReplicaSets
* Services
* Namespaces
* Labels
* Selectors
* ConfigMaps
* Secrets
* Volumes
* PersistentVolumes
* PersistentVolumeClaims
* StorageClasses
* Health probes
* Resource requests and limits
* Scaling
* Rolling updates
* Rollbacks
* Kubernetes networking
* Service discovery
* Ingress
* `kubectl`
* Kubernetes YAML
* Basic Kubernetes troubleshooting

---

# 1. Why Kubernetes?

Start with the problem Kubernetes solves.

Docker allows you to run containers:

```text id="3r5n8z"
Docker
 ├── API container
 ├── PostgreSQL container
 ├── MongoDB container
 └── Redis container
```

But managing many containers across machines introduces additional problems:

* Where should containers run?
* What happens when one crashes?
* How are containers discovered?
* How do containers communicate?
* How do you scale them?
* How do you update them?
* How do you roll back an update?
* How do you manage configuration?
* How do you expose services?

Kubernetes addresses these orchestration problems.

---

# 2. Kubernetes Architecture

Understand the basic structure of a Kubernetes cluster.

Conceptually:

```text id="5q7k2x"
Kubernetes Cluster
│
├── Control Plane
│
└── Worker Nodes
    │
    ├── Pod
    ├── Pod
    └── Pod
```

Understand the responsibilities of the major components.

At a high level:

```text id="6p9m4w"
kubectl
   │
   ▼
Kubernetes API Server
   │
   ▼
Control Plane
   │
   ▼
Worker Nodes
   │
   ▼
Pods
```

The goal is to understand the architecture rather than memorize every internal component.

---

# 3. Local Kubernetes Cluster

Create a local Kubernetes environment.

Choose one suitable solution, such as:

* Minikube
* Kind
* K3d
* Docker Desktop Kubernetes

Use one rather than trying to learn several simultaneously.

The cluster should be capable of running Network Observatory.

---

# 4. kubectl

Learn the Kubernetes command-line interface.

Use `kubectl` to:

* Inspect the cluster
* Create resources
* Apply manifests
* Inspect Pods
* Inspect Deployments
* Inspect Services
* View logs
* Execute commands inside Pods
* Inspect events
* Delete resources
* Scale workloads

Become comfortable answering:

```text id="1z8x4c"
What is running?

Where is it running?

Why isn't it running?

What is this Pod doing?

What Service exposes it?

What configuration is it using?
```

---

# 5. Namespaces

Create a namespace for Network Observatory.

For example:

```text id="m8q4s2"
network-observatory
```

Understand why namespaces exist.

Use the namespace consistently throughout the project.

---

# 6. Pods

Deploy the application as a Pod.

Understand that a Pod is Kubernetes' basic unit of deployment.

Learn:

* Pod lifecycle
* Pod status
* Pod IP addresses
* Container status
* Container restarts
* Pod logs
* Executing commands inside Pods

Understand why Pods should generally be treated as ephemeral.

---

# 7. Deployments

Use a Deployment to manage the API workload.

Understand:

```text id="5k7p2m"
Deployment
    ↓
ReplicaSet
    ↓
Pods
```

The Deployment expresses the desired state.

For example:

```text id="q8m4x1"
desired replicas = 3
```

Kubernetes works toward maintaining that state.

---

# 8. ReplicaSets

Understand the role of a ReplicaSet.

A ReplicaSet maintains the desired number of matching Pods.

For example:

```text id="8z4n7q"
ReplicaSet
    │
    ├── API Pod
    ├── API Pod
    └── API Pod
```

You generally manage ReplicaSets indirectly through Deployments.

Understand why both concepts exist.

---

# 9. Labels and Selectors

Learn how Kubernetes resources identify one another.

For example:

```text id="6x5p2m"
Deployment
    │
    │ selector
    ▼
Pods
```

and:

```text id="4m9q7w"
Service
    │
    │ selector
    ▼
Pods
```

Experiment with incorrect selectors to understand how easily a valid-looking configuration can fail to connect resources.

---

# 10. Services

Pods are ephemeral and their IP addresses can change.

Create Services to provide stable access.

Conceptually:

```text id="7q2m5x"
Client
   │
   ▼
Service
   │
   ▼
Pods
```

Learn the major Service types at a conceptual level.

Determine which are appropriate for Network Observatory.

---

# 11. Kubernetes Networking

Understand how workloads communicate inside the cluster.

Explore:

```text id="3x8m1q"
Pod
 ↓
Service
 ↓
Pod
```

and:

```text id="9k4w6z"
API
 ↓
PostgreSQL
```

Learn Kubernetes DNS and service discovery.

Services should be addressed through stable service names rather than Pod IP addresses.

---

# 12. Application Architecture

Translate the Docker Compose environment from Stage 9 into Kubernetes.

A possible architecture is:

```text id="8m6q2x"
                    Browser
                       │
                       ▼
                    Ingress
                       │
                       ▼
                  API Service
                       │
              ┌────────┼────────┐
              ▼        ▼        ▼
          API Pod    API Pod   API Pod
              │
        ┌─────┼─────┐
        ▼     ▼     ▼
       PG    Mongo  Redis
```

The exact architecture is your decision.

Do not assume every component needs to be replicated identically.

---

# 13. Configuration

Move application configuration into Kubernetes resources.

Learn about:

* ConfigMaps
* Environment variables
* Secrets

Separate:

```text id="q7m5z3"
normal configuration
```

from:

```text id="n9x4k2"
sensitive configuration
```

The container image should remain independent of environment-specific configuration.

---

# 14. Secrets

Use Kubernetes Secrets for sensitive configuration.

Potential examples:

```text id="2m6q8x"
Database credentials
JWT signing secret
External API credentials
```

Understand what Kubernetes Secrets actually provide.

Do not treat a Secret as equivalent to a fully secured external secrets-management system.

Most importantly:

**Do not commit real credentials into the repository.**

---

# 15. Persistent Storage

Understand why containerized databases require persistent storage.

Learn:

```text id="4x8m2q"
PersistentVolume
       │
       ▼
PersistentVolumeClaim
       │
       ▼
Pod
```

Also learn the role of a StorageClass.

Determine which Network Observatory components need persistent storage.

---

# 16. Stateful Components

Consider the difference between:

```text id="6q9m4x"
stateless API
```

and:

```text id="3z7p5w"
stateful database
```

The API can generally be replicated:

```text id="1x5q8m"
API
├── Pod
├── Pod
└── Pod
```

A database requires considerably more care.

Investigate why Kubernetes has concepts specifically intended to support stateful workloads.

You do not need to build a highly available database cluster for this project.

---

# 17. Health Probes

Connect the health endpoints created in Stage 7 to Kubernetes.

Learn:

### Liveness probe

Determines whether a container should be restarted.

### Readiness probe

Determines whether a Pod should receive traffic.

### Startup probe

Allows slow-starting applications time to initialize.

Understand why:

```text id="7m4q9x"
process running
```

does not necessarily mean:

```text id="9x2k6m"
application ready
```

---

# 18. Resource Requests and Limits

Define resource requirements for workloads.

Learn the distinction between:

```text id="5w7m3q"
requests
```

and:

```text id="2q9x4k"
limits
```

Apply appropriate CPU and memory values to the application.

Observe resource usage and understand how Kubernetes uses these values when scheduling workloads.

---

# 19. Scaling

Scale the API.

For example:

```text id="8q4m7z"
1 replica
   ↓
2 replicas
   ↓
3 replicas
```

Observe what happens.

Determine whether the application behaves correctly when any replica receives a request.

This should reinforce the importance of stateless application design.

---

# 20. Monitoring Worker

Network Observatory performs background monitoring.

Consider what happens when the API is scaled:

```text id="5m8q2x"
API Pod 1
API Pod 2
API Pod 3
```

If each Pod runs the monitoring loop, you may accidentally get:

```text id="8x3q7m"
3 monitoring loops
```

all scanning the same network.

Determine how the monitoring worker should be deployed.

Possible architectural approaches include:

```text id="2q6m9w"
separate worker workload
```

or another appropriate execution model.

The important point is to understand the architectural implications of Kubernetes scaling.

---

# 21. Jobs and CronJobs

Investigate Kubernetes Jobs and CronJobs.

Understand when each is appropriate.

A Job represents work that should complete:

```text id="6w8m3q"
Job
 ↓
Run task
 ↓
Complete
```

A CronJob schedules Jobs:

```text id="9q4x7m"
CronJob
   ↓
Job
   ↓
Task
```

Determine whether either is appropriate for any Network Observatory operations.

Do not force Kubernetes scheduling mechanisms into the application simply because they exist.

---

# 22. Ingress

Expose the application externally.

Conceptually:

```text id="7x5m9q"
Browser
   │
   ▼
Ingress
   │
   ▼
Service
   │
   ▼
Pods
```

Learn:

* Host-based routing
* Path-based routing
* TLS
* Ingress controllers

Determine how the frontend and API should be exposed.

---

# 23. Frontend and API Routing

Design the external application structure.

For example:

```text id="3q8m6x"
network-observatory.local/
```

could serve the frontend while:

```text id="5z2w9k"
network-observatory.local/api/
```

routes to FastAPI.

Alternatively, use separate hosts.

The important objective is understanding how traffic enters the cluster and reaches the correct Service.

---

# 24. Rolling Updates

Deploy a new application version.

Observe:

```text id="8m3q7x"
Old Pods
   ↓
New Pods created
   ↓
New Pods become ready
   ↓
Old Pods removed
```

Understand how readiness probes affect the rollout.

Investigate what happens when the new version is unhealthy.

---

# 25. Rollbacks

Deliberately deploy a broken version.

Learn how to:

* Inspect rollout history
* Identify a previous version
* Roll back
* Verify recovery

Understand why controlled deployment history is useful.

---

# 26. Logs

Use Kubernetes tools to inspect application logs.

Investigate:

```text id="2q7m5x"
Current logs
Previous container logs
Logs from individual Pods
```

Relate these logs to the structured application logging from Stage 7.

Understand the difference between:

```text id="6m9x3q"
application logs
```

and:

```text id="4w7q8z"
Kubernetes events
```

---

# 27. Kubernetes Events

Use Kubernetes events to diagnose infrastructure-level problems.

Events may indicate:

```text id="8q2m5x"
Image pull failure
Pod scheduling failure
Probe failure
Volume mount failure
Container restart
```

Learn to use events as part of the troubleshooting process.

---

# 28. YAML Manifests

Create Kubernetes resource definitions using YAML.

Learn:

* Metadata
* Names
* Labels
* Selectors
* Specs
* Nested objects
* Multi-document YAML

You should be able to explain every important field in your manifests.

Avoid copying large manifests without understanding them.

---

# 29. Deployment Workflow

Establish a repeatable deployment process.

Conceptually:

```text id="9m4q7x"
Source code
     ↓
Docker image
     ↓
Image registry / local image
     ↓
Kubernetes deployment
     ↓
Pods
     ↓
Health checks
     ↓
Running application
```

Understand how Kubernetes consumes the Docker images produced in Stage 9.

---

# 30. Troubleshooting

Deliberately break the deployment.

Examples:

```text id="7q3m8x"
Wrong image
Wrong port
Wrong Service selector
Broken ConfigMap
Broken Secret
Incorrect environment variable
Broken health probe
Missing volume
Incorrect Ingress
```

Diagnose each problem using:

```text id="4m8q2x"
kubectl
logs
describe
events
```

The objective is to learn a systematic troubleshooting process.

---

# 31. Security

Perform a basic Kubernetes security review.

Consider:

* Running containers as root
* Container privileges
* Secrets
* Service exposure
* Network access
* Resource limits
* Image security
* Namespace isolation
* Service accounts

Do not attempt to build a complete production Kubernetes security architecture.

Understand the major security concerns introduced by orchestration.

---

# 32. Testing

Test the Kubernetes deployment as a complete system.

### Application

* Frontend loads
* API responds
* Authentication works
* GraphQL works

### Networking

* Ingress reaches the correct Service
* Services reach Pods
* API reaches dependencies

### Persistence

* Data survives Pod replacement

### Scaling

* Multiple API replicas work correctly

### Monitoring

* Monitoring continues correctly

### Recovery

* Failed Pods are replaced
* Unready Pods stop receiving traffic

### Deployment

* Rolling updates work
* Rollbacks work

---

# 33. Milestones

## Milestone 1 — Cluster

Create and understand a local Kubernetes cluster.

---

## Milestone 2 — kubectl

Learn to inspect and control the cluster.

---

## Milestone 3 — Pods

Run the application inside Kubernetes.

---

## Milestone 4 — Deployments

Manage the API using a Deployment.

---

## Milestone 5 — Services

Introduce stable internal networking.

---

## Milestone 6 — Configuration

Introduce ConfigMaps and Secrets.

---

## Milestone 7 — Persistence

Configure persistent storage for stateful components.

---

## Milestone 8 — Health

Configure Kubernetes health probes.

---

## Milestone 9 — Scaling

Run multiple API replicas.

---

## Milestone 10 — Worker

Separate monitoring work appropriately from replicated API workloads.

---

## Milestone 11 — Ingress

Expose the application externally.

---

## Milestone 12 — Updates

Perform rolling updates and rollbacks.

---

## Milestone 13 — Troubleshooting

Intentionally break the deployment and diagnose the failures.

---

## Milestone 14 — Security

Perform a basic Kubernetes security review.

---

# Completion Criteria

Stage 10 is complete when:

* A local Kubernetes cluster is operational.
* Network Observatory runs inside Kubernetes.
* Kubernetes manages the application's Pods through Deployments.
* Services provide stable internal networking.
* Kubernetes DNS is used for service discovery.
* The application uses appropriate ConfigMaps and Secrets.
* Persistent data survives Pod replacement.
* Health probes are configured.
* Resource requests and limits are defined.
* The API can run multiple replicas.
* Monitoring work does not accidentally duplicate because of API scaling.
* The application is accessible through an Ingress or appropriate local equivalent.
* Rolling updates work.
* Rollbacks work.
* Kubernetes logs and events can be inspected.
* Common Kubernetes failures can be diagnosed.
* The application can be rebuilt and redeployed from the project's Docker images.
* Basic Kubernetes security concerns have been reviewed.

You should be able to explain:

* What Kubernetes is.
* Why Kubernetes exists.
* What a Kubernetes cluster is.
* What the control plane does.
* What a node is.
* What a Pod is.
* Why Pods are ephemeral.
* What a Deployment does.
* What a ReplicaSet does.
* What a Service does.
* How Kubernetes service discovery works.
* What labels and selectors do.
* What a Namespace provides.
* What ConfigMaps and Secrets are.
* Why persistent storage is necessary.
* What PersistentVolumes and PersistentVolumeClaims are.
* The difference between stateless and stateful workloads.
* What liveness, readiness, and startup probes do.
* What resource requests and limits do.
* How Kubernetes scales workloads.
* How rolling updates work.
* How rollbacks work.
* What an Ingress does.
* What Jobs and CronJobs are.
* How to troubleshoot a failed Pod.
* Why scaling an API is different from scaling a database.
* Why background workers require special consideration in a replicated application.

---

# Result

Network Observatory now moves from a collection of Docker containers to an orchestrated application:

```text id="6q8m3x"
                       Kubernetes Cluster
                              │
                         ┌────┴────┐
                         │ Ingress │
                         └────┬────┘
                              │
                              ▼
                         API Service
                              │
                    ┌─────────┼─────────┐
                    ▼         ▼         ▼
                  API Pod   API Pod   API Pod
                    │
             ┌──────┼──────┐
             ▼      ▼      ▼
            Worker   ...  Services
                       │
              ┌────────┼────────┐
              ▼        ▼        ▼
          PostgreSQL MongoDB   Redis
```

Docker answers:

> **How do I package and run this application in containers?**

Kubernetes answers:

> **How do I manage those containers as a reliable application system?**

That distinction is the central lesson of this stage.
