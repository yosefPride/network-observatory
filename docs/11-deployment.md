# 11 — Deployment

## Purpose

Take the containerized and Kubernetes-based Network Observatory application and establish a repeatable deployment process.

Up to this point, the application has primarily been developed and run manually.

This stage focuses on the path from:

```text
Source Code
    ↓
Git
    ↓
Build
    ↓
Test
    ↓
Docker Image
    ↓
Registry
    ↓
Kubernetes
    ↓
Running Application
```

The objective is to understand how modern applications move from source code to a running environment.

This stage introduces deployment automation and CI/CD concepts without turning the project into a purely DevOps exercise.

---

# Objectives

By the end of this stage, understand and implement:

* Deployment
* Environments
* Build pipelines
* CI/CD
* Continuous Integration
* Continuous Delivery
* Continuous Deployment
* Git-based workflows
* GitLab
* GitLab CI/CD
* Pipeline stages
* Jobs
* Artifacts
* Docker image builds
* Container registries
* Environment configuration
* Kubernetes deployment automation
* Deployment strategies
* Rollbacks
* Versioning
* Secrets in CI/CD
* Deployment verification

---

# 1. What Is Deployment?

Define what deployment means in the context of the project.

A deployment should move a specific version of the application from:

```text
source code
```

to:

```text
running application
```

For example:

```text
Git commit
    ↓
Application build
    ↓
Tests
    ↓
Docker image
    ↓
Kubernetes
    ↓
Application available
```

Understand that deployment is a process, not simply copying files onto a server.

---

# 2. Environments

Introduce distinct environments.

At minimum, consider:

```text
Development
Production
```

Optionally introduce:

```text
Testing
Staging
```

Understand why environments exist.

Consider differences in:

* Configuration
* Database
* Secrets
* Logging
* Debugging
* Resource limits
* Domain names
* External services

The same application artifact should ideally be deployable to different environments with environment-specific configuration.

---

# 3. Development vs Production

Determine what changes between local development and production.

For example:

```text
Development
├── Debug logging
├── Local databases
├── Development configuration
└── Frequent rebuilds
```

versus:

```text
Production
├── Production configuration
├── Persistent storage
├── Restricted access
├── Stronger security
└── Controlled deployments
```

Do not simply copy the development environment into production.

---

# 4. Git as the Source of Truth

Use Git as the foundation of the deployment process.

Understand:

```text
Commit
   ↓
Branch
   ↓
Merge
   ↓
Deployment
```

Determine which Git events should trigger deployment.

For example:

```text
push → CI
merge → build
release → production deployment
```

The exact workflow is your decision.

---

# 5. Versioning

Give deployed application versions meaningful identities.

For example:

```text
v0.1.0
v0.2.0
v1.0.0
```

Connect application versions to:

* Git commits
* Docker image tags
* Kubernetes deployments

Avoid relying entirely on:

```text
latest
```

A deployed application should be traceable to a specific source revision.

---

# 6. Build Pipeline

Create a pipeline that can automatically build the application.

Conceptually:

```text
Source
  ↓
Install dependencies
  ↓
Build
  ↓
Test
  ↓
Docker image
```

The pipeline should fail if an important step fails.

The goal is to make the build reproducible rather than dependent on the developer's machine.

---

# 7. Continuous Integration

Understand Continuous Integration.

The basic idea:

```text
Developer
    ↓
Push code
    ↓
CI pipeline
    ↓
Build
    ↓
Tests
    ↓
Result
```

CI should provide fast feedback about whether a change is safe to merge.

Determine which checks Network Observatory should perform automatically.

Potential checks include:

* Python tests
* JavaScript tests
* Linting
* Formatting
* Docker build
* API tests

---

# 8. Continuous Delivery

Understand the distinction between:

```text
Continuous Integration
```

and:

```text
Continuous Delivery
```

Continuous Delivery means the application is continuously kept in a deployable state.

A conceptual pipeline might be:

```text
Commit
 ↓
Test
 ↓
Build
 ↓
Package
 ↓
Ready for deployment
```

Deployment to production may still require an explicit approval.

---

# 9. Continuous Deployment

Investigate Continuous Deployment.

Conceptually:

```text
Commit
 ↓
Tests
 ↓
Build
 ↓
Deploy
 ↓
Production
```

No manual deployment step is required when the pipeline succeeds.

Compare this with Continuous Delivery.

Determine which approach is appropriate for Network Observatory.

---

# 10. GitLab

Use GitLab as the CI/CD platform for the project.

Learn the major components relevant to deployment:

* Repository
* Pipelines
* Jobs
* Runners
* Artifacts
* Variables
* Environments
* Deployments

Do not attempt to learn every GitLab feature.

Focus on the parts required to build and deploy the application.

---

# 11. GitLab CI/CD

Create a GitLab CI/CD configuration.

The pipeline should be represented as code.

Conceptually:

```text
.gitlab-ci.yml
```

Define stages such as:

```text
test
build
package
deploy
```

The exact pipeline structure should evolve as the project grows.

---

# 12. Pipeline Stages

Understand why pipelines are divided into stages.

For example:

```text
Test
  ↓
Build
  ↓
Image
  ↓
Deploy
```

A later stage should generally depend on successful completion of earlier stages.

For example:

```text
Tests fail
    ↓
No deployment
```

---

# 13. Pipeline Jobs

Understand the difference between:

```text
stage
```

and:

```text
job
```

A stage represents a logical phase.

A job performs a specific task.

For example:

```text
test
├── Python tests
├── JavaScript tests
└── API tests
```

Jobs may execute independently where appropriate.

---

# 14. CI Runners

Understand where CI jobs actually execute.

Learn the role of a GitLab Runner.

Conceptually:

```text
GitLab
   │
   ▼
Pipeline
   │
   ▼
Runner
   │
   ▼
Job
```

Understand that the runner provides the environment in which pipeline commands execute.

---

# 15. Artifacts

Learn what CI artifacts are.

Use artifacts where useful for:

* Test reports
* Build output
* Generated documentation
* Debugging failed pipelines

Understand the difference between:

```text
artifact
```

and:

```text
Docker image
```

They solve different problems.

---

# 16. Docker Image Pipeline

Integrate Docker into CI.

The pipeline should be capable of:

```text
Source
   ↓
Docker build
   ↓
Image
```

The image should be tagged using an identifiable version.

For example:

```text
network-observatory:<version>
```

or an equivalent strategy tied to the Git revision.

---

# 17. Container Registry

Introduce a container registry.

The deployment process becomes:

```text
CI Runner
    ↓
Build Docker image
    ↓
Push image
    ↓
Container Registry
    ↓
Kubernetes
```

Understand why the registry acts as the bridge between:

```text
build environment
```

and:

```text
deployment environment
```

---

# 18. Image Promotion

Understand the idea of promoting an existing image between environments.

For example:

```text
Image
 │
 ├── Development
 │
 ├── Staging
 │
 └── Production
```

Avoid rebuilding the application separately for each environment when possible.

The artifact being tested should be the artifact being deployed.

---

# 19. Configuration

Separate deployment configuration from application artifacts.

For example:

```text
Docker image
    ↓
same artifact
    │
    ├── Development configuration
    └── Production configuration
```

Configuration should be provided by the deployment environment.

Do not create separate application images simply because environments have different configuration values.

---

# 20. CI/CD Secrets

Determine how sensitive values should be provided to pipelines.

Potential secrets include:

```text
Registry credentials
Kubernetes credentials
JWT secrets
External API credentials
Database credentials
```

Do not place secrets directly in:

```text
.gitlab-ci.yml
```

or source code.

Learn how CI/CD platforms provide protected variables and secrets.

---

# 21. Kubernetes Deployment

Connect CI/CD to Kubernetes.

Conceptually:

```text
GitLab
   ↓
CI Pipeline
   ↓
Docker Image
   ↓
Registry
   ↓
Kubernetes
   ↓
Deployment
```

The pipeline should be able to update the Kubernetes deployment to use a new image version.

---

# 22. Deployment Configuration

Determine how Kubernetes manifests should be managed.

Consider:

```text
base configuration
```

and:

```text
environment-specific configuration
```

Avoid duplicating large amounts of YAML between environments.

Investigate appropriate Kubernetes configuration approaches.

The goal is to understand the problem before choosing a particular tool or structure.

---

# 23. Automated Deployment

Create an automated deployment process.

A successful pipeline should eventually be capable of:

```text
Commit
 ↓
Test
 ↓
Build
 ↓
Create image
 ↓
Push image
 ↓
Deploy to Kubernetes
 ↓
Wait for rollout
 ↓
Verify application
```

Do not consider the deployment successful merely because the Kubernetes command completed.

The application itself must be verified.

---

# 24. Deployment Verification

After deployment, verify that the new version is actually healthy.

Check:

```text
Pod status
Service availability
Health endpoint
Application logs
Deployment rollout
```

Potentially verify:

```text
GET /health
```

and other basic application functionality.

The pipeline should detect failed deployments where practical.

---

# 25. Deployment Failure

Deliberately introduce a broken deployment.

Examples:

```text
Invalid image
Broken environment variable
Bad configuration
Failed health check
Application startup failure
```

Observe what happens.

Determine how the pipeline should react.

A deployment pipeline should not blindly report success because the Kubernetes API accepted the configuration.

---

# 26. Rollbacks

Integrate rollback thinking into the deployment process.

A deployment should be traceable to a specific version.

Conceptually:

```text
v1
 ↓
v2
 ↓
v3
```

If `v3` is broken:

```text
v3
 ↓
rollback
 ↓
v2
```

Understand both:

```text
automatic rollback
```

and:

```text
manual rollback
```

and determine which is appropriate.

---

# 27. Deployment Strategies

Investigate different deployment strategies.

At minimum understand:

### Recreate

```text
Old version
    ↓
Stop
    ↓
New version
```

### Rolling

```text
Old Pods
   ↓
New Pods gradually introduced
   ↓
Old Pods removed
```

Investigate more advanced approaches such as:

* Blue-green
* Canary

You do not need to implement every strategy.

Understand the tradeoffs.

---

# 28. Database Migrations

Consider how database schema changes affect deployment.

For example:

```text
Application v1
     ↓
Database schema v1
```

becomes:

```text
Application v2
     ↓
Database schema v2
```

Determine how migrations should be executed as part of deployment.

Think about what happens if:

```text
migration succeeds
application deployment fails
```

or:

```text
application deployment succeeds
migration fails
```

This is an important real-world deployment problem.

---

# 29. Backups

Consider deployment and data safety together.

Determine how important application data should be backed up.

At minimum, understand:

* What needs to be backed up
* How frequently
* Where backups should be stored
* How restoration would work

You do not need to build a sophisticated backup platform.

The goal is to understand that deployment automation does not replace data protection.

---

# 30. Environments and Promotion

Create a clear promotion path.

For example:

```text
Development
     ↓
Testing
     ↓
Staging
     ↓
Production
```

Not every project needs all four environments.

Determine an appropriate structure for Network Observatory.

The important concept is that promotion should be deliberate and traceable.

---

# 31. Deployment History

Maintain enough information to answer:

```text
What version is running?

When was it deployed?

Who or what deployed it?

What Git commit produced it?

What Docker image is running?

What changed between versions?
```

Connect:

```text
Git commit
      ↓
Docker image
      ↓
Kubernetes deployment
```

This establishes deployment traceability.

---

# 32. Logs and Deployment Debugging

Use the logging and monitoring capabilities from Stage 7 to investigate deployment problems.

A failed deployment should be diagnosable using:

```text
CI logs
Kubernetes events
Application logs
Health checks
Deployment status
```

This ties together several previous stages.

---

# 33. Deployment Documentation

Document how to deploy Network Observatory.

A new developer should be able to understand:

```text
How do I build it?

How do I run it?

How do I deploy it?

How do I verify it?

How do I roll it back?
```

The deployment process should not exist only inside someone's memory.

---

# 34. Testing

Test the deployment pipeline itself.

### CI

* Pipeline starts
* Tests execute
* Failed tests stop the pipeline
* Successful tests allow later stages

### Build

* Docker image builds
* Image is tagged correctly
* Image is pushed successfully

### Deployment

* Kubernetes receives the new version
* Rollout completes
* Health checks pass

### Failure

* Broken deployment is detected
* Application does not silently remain unhealthy

### Rollback

* Previous version can be restored
* Application becomes healthy again

---

# 35. Milestones

## Milestone 1 — Environments

Define the project's deployment environments.

---

## Milestone 2 — Git Workflow

Connect source-control changes to the deployment lifecycle.

---

## Milestone 3 — CI

Create an automated test/build pipeline.

---

## Milestone 4 — GitLab

Run the pipeline through GitLab CI/CD.

---

## Milestone 5 — Docker Build

Build versioned Docker images automatically.

---

## Milestone 6 — Registry

Push images to a container registry.

---

## Milestone 7 — Kubernetes Deployment

Deploy images automatically to Kubernetes.

---

## Milestone 8 — Verification

Verify the application after deployment.

---

## Milestone 9 — Rollback

Demonstrate recovery from a failed deployment.

---

## Milestone 10 — Promotion

Establish a controlled path between environments.

---

## Milestone 11 — Database Changes

Integrate database migration considerations into deployment.

---

## Milestone 12 — Documentation

Document the complete deployment process.

---

# Completion Criteria

Stage 11 is complete when:

* Network Observatory has clearly defined deployment environments.
* Git is integrated into the deployment workflow.
* CI automatically builds and tests the application.
* GitLab CI/CD runs the pipeline.
* Docker images are built automatically.
* Images receive traceable version identifiers.
* Images are pushed to a container registry.
* Kubernetes can deploy the generated image.
* Deployment configuration is separated from application artifacts.
* CI/CD secrets are handled securely.
* Deployments are automatically verified.
* Failed deployments can be detected.
* The application can be rolled back.
* Deployment history is traceable to Git commits and Docker images.
* Database migrations have a defined deployment strategy.
* Basic backup and restoration considerations have been addressed.
* The deployment process is documented.
* The entire process can be reproduced without manually performing every step.

You should be able to explain:

* What deployment means.
* The difference between CI, Continuous Delivery, and Continuous Deployment.
* What a CI/CD pipeline is.
* What a GitLab Runner does.
* What pipeline stages and jobs are.
* What CI artifacts are.
* What a container registry does.
* Why Docker images should be versioned.
* Why the tested artifact should ideally be the deployed artifact.
* How CI/CD secrets should be handled.
* How CI can deploy to Kubernetes.
* How a deployment can be verified.
* Why a successful deployment command does not necessarily mean a successful application deployment.
* What rolling deployments are.
* What blue-green and canary deployments are.
* Why database migrations complicate deployments.
* Why deployment traceability matters.
* Why backups are separate from deployment.
* How to recover from a failed deployment.

---

# Result

Network Observatory now has a complete path from source code to a running application:

```text
                         Git
                          │
                          ▼
                    CI/CD Pipeline
                          │
             ┌────────────┼────────────┐
             ▼            ▼            ▼
           Test          Build       Validate
                          │
                          ▼
                    Docker Image
                          │
                          ▼
                    Container
                     Registry
                          │
                          ▼
                     Kubernetes
                          │
                          ▼
                    Deployment
                          │
                          ▼
                   Running System
                          │
                          ▼
                   Health Checks
                          │
                          ▼
                      Verified
```

The important lesson is that **deployment is a chain of reproducible steps**, not a single command.

You should be able to take a Git commit, turn it into a versioned Docker image, deploy that image to Kubernetes, verify that the application is healthy, identify exactly what version is running, and recover if the deployment fails.
