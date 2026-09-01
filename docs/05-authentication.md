# 05 — Authentication

## Purpose

Introduce users, authentication, and authorization to Network Observatory.

Until now, the API has effectively been open to anyone who can reach it.

This stage introduces an identity system that allows the application to:

* Create user accounts
* Authenticate users
* Issue authentication tokens
* Verify authenticated requests
* Protect API endpoints
* Control access to operations based on permissions

The primary authentication mechanism will be JWT-based authentication.

---

# Objectives

By the end of this stage, understand and implement:

* Authentication
* Authorization
* Identity
* Password hashing
* Password verification
* JWT
* Access tokens
* Token claims
* Token expiration
* HTTP authentication headers
* Protected endpoints
* Permissions
* Roles
* Authentication failures
* Authorization failures

---

# 1. Authentication vs Authorization

Understand the distinction before implementing either.

### Authentication

Answers:

> Who are you?

```text
User
 ↓
Credentials
 ↓
Authentication
 ↓
Identity
```

### Authorization

Answers:

> What are you allowed to do?

```text
Identity
 ↓
Permissions
 ↓
Allowed / Denied
```

These are separate concerns and should remain separate in the application.

---

# 2. Users

Introduce a user entity into the application.

A user should have an identity that can be associated with authenticated requests.

Determine which information the application actually needs to store.

Potential information includes:

```text
User
├── ID
├── Username / email
├── Password hash
├── Created timestamp
└── Account status
```

Do not store plaintext passwords.

The exact user model is your responsibility.

---

# 3. Password Security

Learn how passwords should be handled by applications.

Understand:

* Hashing
* Salting
* Password verification
* Why encryption is not the same as password hashing
* Why passwords should never be stored directly

Choose an appropriate password-hashing algorithm and Python implementation.

The application should store only the resulting password hash.

Conceptually:

```text
Registration

Password
   ↓
Password hashing
   ↓
Password hash
   ↓
Database
```

Authentication should work in the opposite direction:

```text
Login

Password
   ↓
Password verification
   ↓
Stored password hash
   ↓
Authenticated / rejected
```

---

# 4. Registration

Add an API operation for creating a user account.

For example:

```text
POST /auth/register
```

The endpoint should:

1. Validate the submitted information.
2. Determine whether the user already exists.
3. Hash the password.
4. Store the user.
5. Return an appropriate response.

Consider what should happen when:

* Required information is missing.
* Input is malformed.
* The user already exists.
* The password does not meet the application's requirements.
* The database operation fails.

---

# 5. Login

Add an authentication endpoint.

For example:

```text
POST /auth/login
```

The conceptual flow is:

```text
Credentials
     ↓
Find user
     ↓
Verify password
     ↓
Create authentication token
     ↓
Return token
```

Invalid credentials should not reveal unnecessary information about the account.

---

# 6. JWT

Learn what a JSON Web Token is and why it can be used for authentication.

Understand the basic JWT structure:

```text
Header
.
Payload
.
Signature
```

Learn the purpose of:

* Header
* Payload
* Claims
* Signature
* Secret/signing key
* Expiration

Understand that a JWT is **signed, not encrypted by default**.

Do not put sensitive information into token claims simply because the token can carry arbitrary data.

---

# 7. Token Claims

Determine which claims the application needs.

Potential claims include:

```text
sub
iat
exp
```

where appropriate.

Understand:

* Subject
* Issued-at time
* Expiration time

The token should contain enough information for the application to identify the authenticated user without unnecessarily duplicating user data.

---

# 8. Token Lifetime

Authentication tokens should not be valid forever.

Define an appropriate expiration policy.

Understand:

```text
issued
   ↓
valid
   ↓
expired
```

Determine what the API should return when an expired token is presented.

Token expiration should be enforced by the server.

---

# 9. Authorization Header

Learn how clients normally send bearer tokens.

The expected request structure is conceptually:

```text
Authorization: Bearer <token>
```

Understand the relationship between:

```text
HTTP header
      ↓
Bearer token
      ↓
JWT
      ↓
Authenticated user
```

Do not pass authentication tokens through arbitrary query parameters.

---

# 10. Authentication Dependency

Create a reusable mechanism for determining the current authenticated user.

Conceptually:

```text
HTTP Request
     ↓
Extract token
     ↓
Validate token
     ↓
Identify user
     ↓
Current User
     ↓
Endpoint
```

Endpoints should not each implement their own JWT parsing and validation logic.

Use FastAPI's dependency system where appropriate.

---

# 11. Protecting Endpoints

Start protecting API operations.

For example:

```text
GET /devices
GET /devices/{id}
POST /scans
GET /events
```

An unauthenticated request should be rejected where authentication is required.

Test both:

```text
authenticated request
```

and:

```text
unauthenticated request
```

---

# 12. Authorization

Once authentication works, introduce authorization.

Determine which operations should require which permissions.

For example:

```text
Observer
├── View devices
├── View services
└── View events

Administrator
├── View devices
├── View services
├── View events
└── Start scans
```

These are examples only.

Design the permission model based on the application's actual requirements.

---

# 13. Roles and Permissions

Decide whether the application should use:

```text
Role → Permissions
```

rather than hard-coding authorization rules directly into individual endpoints.

For example:

```text
Administrator
    ↓
scan:create
device:read
event:read

Observer
    ↓
device:read
event:read
```

The exact roles and permissions are your decision.

Keep the initial system small.

---

# 14. Authorization Flow

The eventual request flow should conceptually resemble:

```text
Request
   ↓
Extract JWT
   ↓
Validate JWT
   ↓
Identify User
   ↓
Check Permission
   ↓
Allowed?
  / \
yes  no
 |    |
 ▼    ▼
API  403
```

Authentication failure and authorization failure should be distinguishable.

Conceptually:

```text
401 Unauthorized
→ The request has not successfully established authentication.

403 Forbidden
→ The user is authenticated but lacks permission.
```

---

# 15. User Information

Provide a way for an authenticated client to retrieve information about the current user.

For example:

```text
GET /auth/me
```

This endpoint should return appropriate user information without exposing sensitive authentication data.

The response should never contain the user's password or password hash.

---

# 16. Authentication Errors

Handle common failure cases explicitly.

Test:

```text
Missing token
Malformed token
Invalid signature
Expired token
Invalid credentials
Unknown user
Insufficient permissions
```

The API should return appropriate HTTP responses without exposing secrets or internal implementation details.

---

# 17. Configuration and Secrets

Authentication introduces secrets that should not be committed to the repository.

Examples include:

```text
JWT signing key
Database credentials
Other authentication configuration
```

Learn how configuration should be supplied through environment variables or another appropriate configuration mechanism.

Do not commit actual secrets to Git.

The repository should contain safe development examples where necessary.

---

# 18. API Documentation

Update the OpenAPI documentation to accurately describe authentication.

The API documentation should make it possible for a client to understand:

```text
How to authenticate
How to provide the token
Which endpoints require authentication
Which endpoints require specific permissions
```

Inspect how FastAPI represents security requirements in OpenAPI.

---

# 19. Postman

Extend the Postman collection from Stage 4.

Create requests for:

```text
Register
Login
Get current user
Authenticated endpoint
Unauthenticated endpoint
Unauthorized endpoint
```

Test the complete authentication flow:

```text
Register
   ↓
Login
   ↓
Receive JWT
   ↓
Send JWT
   ↓
Access protected endpoint
```

Also test invalid and expired tokens.

---

# 20. Testing

Add automated tests for authentication and authorization.

### Registration

Test:

* Valid registration
* Duplicate user
* Invalid input
* Password validation
* Database failure

### Login

Test:

* Correct credentials
* Incorrect password
* Unknown user
* Invalid input

### JWT

Test:

* Valid token
* Expired token
* Invalid signature
* Malformed token
* Missing token

### Authorization

Test:

* User with permission
* User without permission
* Unauthenticated request

### User endpoint

Test:

```text
GET /auth/me
```

with valid and invalid authentication.

---

# 21. Security Review

Before completing the stage, deliberately review the implementation for common mistakes.

Check:

* Are passwords ever stored in plaintext?
* Are password hashes exposed through API responses?
* Are JWT signing secrets committed?
* Are tokens validated on every protected request?
* Are expired tokens rejected?
* Can an authenticated user access operations they should not?
* Are authentication and authorization failures distinguishable?
* Are sensitive values appearing in logs?
* Are error messages revealing unnecessary information?

The goal is to understand **why** each protection exists.

---

# 22. Milestones

## Milestone 1 — Users

Create the user model and persistence mechanism.

---

## Milestone 2 — Passwords

Implement secure password hashing and verification.

---

## Milestone 3 — Registration

Create the registration endpoint.

---

## Milestone 4 — Login

Authenticate users and issue JWTs.

---

## Milestone 5 — Protected API

Require authentication for selected endpoints.

---

## Milestone 6 — Current User

Implement an authenticated current-user endpoint.

---

## Milestone 7 — Authorization

Introduce roles and/or permissions.

---

## Milestone 8 — Security

Handle token expiration, configuration, secrets, and authentication failures.

---

## Milestone 9 — Testing

Create automated authentication and authorization tests.

---

## Milestone 10 — Documentation

Update OpenAPI and Postman to represent the complete authentication flow.

---

# Completion Criteria

Stage 5 is complete when:

* Users can register.
* Passwords are securely hashed.
* Users can authenticate.
* Successful authentication produces a JWT.
* JWTs have an expiration policy.
* Protected endpoints reject unauthenticated requests.
* The API can identify the current user.
* Authorization rules determine whether an authenticated user can perform an operation.
* Authentication and authorization failures return appropriate HTTP responses.
* Sensitive information is not returned by the API.
* Authentication secrets are externalized from source code.
* Automated tests cover authentication and authorization.
* OpenAPI documents the authentication mechanism.
* The complete authentication flow can be tested through Postman.

You should be able to explain:

* The difference between authentication and authorization.
* Why passwords must be hashed.
* The difference between hashing and encryption.
* What a JWT is.
* What the three parts of a JWT represent.
* What a JWT signature provides.
* Why JWT payloads should not contain sensitive information by default.
* What token expiration accomplishes.
* What a bearer token is.
* The difference between HTTP 401 and 403.
* How FastAPI can determine the current authenticated user.
* How authorization differs from authentication.
* How roles can map to permissions.
* How authentication secrets should be managed.

---

# Result

The API now has an identity and access-control layer:

```text
                     HTTP Request
                           │
                           ▼
                    Authentication
                           │
                    ┌──────┴──────┐
                    │             │
                  Valid         Invalid
                    │             │
                    ▼             ▼
              Current User       401
                    │
                    ▼
              Authorization
                    │
              ┌─────┴─────┐
              │           │
            Allowed      Denied
              │           │
              ▼           ▼
          Application     403
             Logic
```

Network Observatory now knows **who is making a request** and **whether that user is permitted to perform the requested operation**.

The web interface built in Stage 6 can therefore communicate with an API that already has a defined authentication and authorization model.
