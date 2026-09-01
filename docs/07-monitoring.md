# 07 — Monitoring

## Purpose

Transform Network Observatory from a system that can perform individual network scans into a system that can **continuously observe a network over time**.

Stage 2 established network discovery.

Stage 3 gave the application persistent historical data.

Stage 4 exposed that data through an API.

Stage 5 introduced authentication.

Stage 6 made the system usable through a browser.

This stage connects those capabilities into a monitoring system.

The application should now be able to repeatedly observe a network, detect changes, record those changes, and present the resulting history to the user.

---

# Objectives

By the end of this stage, understand and implement:

* Continuous monitoring
* Scheduled tasks
* Background work
* State comparison
* Change detection
* Availability
* Uptime
* Historical observations
* Event generation
* Logging
* Log levels
* Structured logging
* Metrics
* Health checks
* Monitoring dashboards
* Polling
* Failure detection
* Graceful recovery

---

# 1. From Scanning to Monitoring

A single scan answers:

> What does the network look like right now?

Monitoring asks:

> How has the network changed over time?

The fundamental loop becomes:

```text id="8w7x21"
Scan
 ↓
Observe
 ↓
Compare with previous state
 ↓
Detect changes
 ↓
Record events
 ↓
Wait
 ↓
Scan again
```

The application should be able to repeat this process automatically.

---

# 2. Current State vs Historical State

Build on the persistence model from Stage 3.

Distinguish between:

```text id="3j7j2c"
Current state
```

and:

```text id="6o2g3z"
Historical observations
```

For example:

```text id="i2y1e6"
Device
192.168.1.20
```

may have the following history:

```text id="8v0l8e"
10:00  discovered
10:05  online
10:10  online
10:15  offline
10:20  offline
10:25  online
```

The system should preserve this history rather than simply replacing the previous value.

---

# 3. Change Detection

Compare the results of consecutive scans.

Potential changes include:

```text id="j8y0m1"
Device discovered
Device disappeared
Device returned
Hostname changed
MAC address changed
Service appeared
Service disappeared
Service state changed
```

Conceptually:

```text id="qz0r2y"
Previous Scan
      │
      │
      ▼
   Compare
      ▲
      │
      │
Current Scan
      │
      ▼
Detected Changes
```

The comparison mechanism should operate on structured data rather than formatted CLI output.

---

# 4. Events

Represent detected changes as events.

For example:

```text id="6w7z3c"
DeviceDiscovered
DeviceOffline
DeviceOnline
ServiceDiscovered
ServiceRemoved
HostnameChanged
```

The exact event model is your responsibility.

For each event, determine what information should be recorded.

Potential information includes:

```text id="b1y0wy"
Event ID
Event type
Device
Timestamp
Previous state
New state
Scan
```

Events become the foundation for the application's historical view.

---

# 5. Availability

Define what "online" means for Network Observatory.

A device may:

* Respond to ICMP
* Respond to ARP
* Accept TCP connections
* Reject all tested ports
* Temporarily fail to respond

Determine what evidence should cause the system to consider a device available.

Document the definition.

Avoid treating:

```text id="4yr8wq"
no response
```

as automatically equivalent to:

```text id="d9p7zr"
device does not exist
```

Network monitoring involves uncertainty.

---

# 6. Uptime

Use historical observations to calculate availability.

Potential metrics include:

```text id="x3k9aq"
Current status
Time online
Time offline
Uptime percentage
Last seen
Last state change
```

For example:

```text id="v7v7w9"
Device
192.168.1.20

Status: Online
Last seen: 30 seconds ago
Uptime: 99.4%
```

Define exactly how uptime is calculated.

Be explicit about:

* Observation intervals
* Missing scans
* Scanner failures
* Device failures
* Monitoring downtime

Do not silently treat missing data as device downtime.

---

# 7. Monitoring Scheduler

Introduce automatic repeated scanning.

For example:

```text id="9x0kz4"
Every 60 seconds:

    perform scan
        ↓
    process results
        ↓
    detect changes
        ↓
    persist events
```

Determine how the scheduler should operate.

Consider:

* Scan interval
* Overlapping scans
* Failed scans
* Application restarts
* Long-running scans
* Configuration changes

The scheduler should not accidentally start multiple copies of the same monitoring task.

---

# 8. Background Tasks

The monitoring loop should not block normal API requests.

Conceptually:

```text id="u2c8x8"
Application
│
├── API
│
└── Monitoring worker
       │
       ├── Scan
       ├── Compare
       └── Record
```

Understand the difference between:

```text id="b2c6p9"
HTTP request processing
```

and:

```text id="h4f2tx"
long-running background work
```

Determine an appropriate mechanism for running monitoring work alongside FastAPI.

Do not assume that an in-process background task is automatically suitable for every production architecture.

---

# 9. Monitoring Configuration

Allow monitoring behavior to be configured.

Potential configuration:

```text id="g8bqg7"
Network to monitor
Scan interval
Ports to check
Discovery method
Monitoring enabled/disabled
```

Determine which configuration belongs in:

```text id="l4w4y7"
environment configuration
```

and which belongs in:

```text id="m0z4n8"
application/database state
```

Configuration should not require changing source code.

---

# 10. Logging

Expand the logging introduced in Stage 2.

Learn and use log levels such as:

```text id="u5d8lq"
DEBUG
INFO
WARNING
ERROR
CRITICAL
```

Determine what belongs at each level.

For example:

```text id="w3b2se"
INFO
Monitoring scan started

DEBUG
Scanning 192.168.1.20

WARNING
Device stopped responding

ERROR
Database operation failed
```

Avoid logging every implementation detail at INFO level.

---

# 11. Structured Logging

Move toward structured logs.

Instead of only:

```text id="r5c3p1"
Device went offline
```

record useful structured context such as:

```text id="0a0q7d"
event=device_offline
device_id=...
ip=...
timestamp=...
scan_id=...
```

The exact format is your decision.

The objective is to make logs useful to both humans and machines.

---

# 12. Logging Security

Review what information is safe to log.

Do not log:

* Passwords
* Authentication tokens
* Secrets
* Sensitive credentials

Consider whether IP addresses, usernames, or other application information should be logged depending on the environment.

Logging should provide observability without becoming a source of unnecessary information exposure.

---

# 13. Application Health

Introduce health checks.

The API should provide a way to determine whether the application itself is functioning.

For example:

```text id="8k8m36"
GET /health
```

A basic health check can establish:

```text id="7x5x1m"
Application is running
```

A deeper health check may verify dependencies such as:

```text id="n8t2bc"
Application
   ├── PostgreSQL
   ├── MongoDB
   └── Redis
```

Determine the difference between:

```text id="y9r8l6"
liveness
```

and:

```text id="r5j6yk"
readiness
```

---

# 14. Monitoring the Monitor

The monitoring system itself can fail.

Track information such as:

```text id="a6v0zx"
Last successful scan
Last failed scan
Current scan
Scan duration
Consecutive failures
```

The system should make it possible to distinguish:

```text id="7j7j8r"
Device is offline
```

from:

```text id="f8j3v0"
Monitoring system failed to scan the network
```

This distinction is critical.

A monitoring system cannot confidently report an outage when the monitoring system itself is broken.

---

# 15. Scan Performance

Measure how long scans take.

Record information such as:

```text id="p6a4xd"
Scan started
Scan completed
Duration
Hosts scanned
Hosts discovered
Ports checked
Errors
```

Use this information to investigate performance.

Questions to answer:

* How does scan duration change as the network grows?
* How does concurrency affect scan time?
* What happens when many hosts do not respond?
* What happens when a scan takes longer than its configured interval?

---

# 16. Metrics

Introduce application metrics.

Potential metrics include:

```text id="k5j5z6"
scans_total
scans_failed
scan_duration
devices_discovered
devices_online
devices_offline
events_generated
```

You do not need to build a complete enterprise metrics system.

The objective is to understand what metrics are and how they differ from logs.

---

# 17. Logs vs Metrics vs Events

Understand the distinction:

### Logs

Detailed records of application activity.

```text id="75qk9n"
"Scan failed because database connection timed out."
```

### Metrics

Numerical measurements over time.

```text id="j6p0b8"
scan_duration = 2.31s
```

### Events

Meaningful changes in application state.

```text id="t9g8b3"
Device became offline.
```

A mature monitoring system may use all three.

---

# 18. Dashboard Improvements

Extend the frontend dashboard from Stage 6.

Display monitoring information such as:

```text id="w7v8ec"
Devices online
Devices offline
Recent events
Last scan
Next scan
Scan duration
Uptime
Monitoring status
```

The dashboard should answer:

> What is happening on my network right now?

and:

> Has anything changed recently?

---

# 19. Real-Time Updates

The frontend should eventually reflect monitoring changes without requiring the user to manually refresh the page.

Investigate:

* Polling
* Server-Sent Events
* WebSockets

Compare their characteristics.

Consider:

```text id="x6v1pg"
complexity
latency
server resources
browser support
connection management
```

Choose an approach appropriate for Network Observatory.

You do not need to implement every mechanism.

---

# 20. Monitoring API

Add API endpoints for monitoring information.

Potential endpoints include:

```text id="1x3qg8"
GET /monitoring/status
GET /monitoring/config
GET /devices/{id}/availability
GET /devices/{id}/events
GET /scans/recent
```

The exact API should be derived from what the frontend actually needs.

Avoid exposing internal scheduler implementation details as API endpoints.

---

# 21. Failure Recovery

Deliberately cause monitoring failures.

Test situations such as:

```text id="8l1l3p"
Database unavailable
Redis unavailable
Network unavailable
Scanner exception
Device timeout
Application restart
Long-running scan
```

Determine how the monitoring system should recover.

The system should be able to resume monitoring after temporary failures without requiring manual intervention wherever practical.

---

# 22. Testing

Add automated tests for monitoring behavior.

Test:

### Change detection

```text id="9f3x47"
New device
Removed device
Returned device
New service
Removed service
Changed hostname
```

### Availability

Test transitions:

```text id="3q4q5r"
unknown → online
online → offline
offline → online
```

### Scheduler

Test:

* Monitoring starts
* Monitoring runs repeatedly
* Failed scans do not permanently stop monitoring
* Overlapping scans are handled correctly

### Health

Test:

```text id="5g9p1x"
healthy
dependency unavailable
```

### Metrics

Verify that important metrics change as expected.

---

# 23. Milestones

## Milestone 1 — Repeated Scans

Run the discovery engine automatically at a configured interval.

---

## Milestone 2 — State Comparison

Compare consecutive scans.

---

## Milestone 3 — Events

Generate and persist meaningful network events.

---

## Milestone 4 — Availability

Track online/offline state and historical availability.

---

## Milestone 5 — Scheduler

Run monitoring independently from API requests.

---

## Milestone 6 — Logging

Introduce structured application logging.

---

## Milestone 7 — Health

Add application and dependency health checks.

---

## Milestone 8 — Metrics

Collect useful monitoring metrics.

---

## Milestone 9 — Dashboard

Expose monitoring information through the frontend.

---

## Milestone 10 — Live Updates

Introduce a mechanism for delivering monitoring changes to the browser.

---

## Milestone 11 — Recovery

Test and improve behavior when monitoring dependencies fail.

---

# Completion Criteria

Stage 7 is complete when:

* The application can monitor a configured network repeatedly.
* Scans run independently of individual API requests.
* Consecutive scans can be compared.
* Meaningful network changes generate events.
* Device availability is tracked over time.
* Uptime can be calculated from historical observations.
* Monitoring failures are distinguishable from device failures.
* Monitoring configuration is externalized appropriately.
* Application logging is structured and useful.
* Sensitive information is not written to logs.
* Health checks exist.
* Monitoring metrics exist.
* The frontend displays current monitoring information.
* The frontend can receive or retrieve monitoring updates.
* Temporary failures can be recovered from appropriately.
* Automated tests cover the monitoring logic.

You should be able to explain:

* The difference between scanning and monitoring.
* How state changes can be detected between observations.
* Why historical observations are necessary for uptime calculations.
* What an event represents.
* Why monitoring failures must be distinguished from monitored-system failures.
* The difference between logs, metrics, and events.
* What structured logging provides.
* What liveness and readiness mean.
* Why background monitoring work should not block API requests.
* How scheduled work behaves when an execution takes longer than its interval.
* The tradeoffs between polling, SSE, and WebSockets.
* How monitoring systems recover from temporary failures.

---

# Result

Network Observatory has now evolved from a network scanner into a monitoring system:

```text id="9z8v5c"
                       Network
                          │
                          ▼
                  Discovery Engine
                          │
                          ▼
                     Observation
                          │
                          ▼
                  State Comparison
                          │
                    ┌─────┴─────┐
                    ▼           ▼
                 No Change    Change
                    │           │
                    │           ▼
                    │         Event
                    │           │
                    └─────┬─────┘
                          ▼
                      Persistence
                          │
              ┌───────────┼───────────┐
              ▼           ▼           ▼
           History      Metrics      Logs
              │
              ▼
          Monitoring API
              │
              ▼
           Frontend
```

The system can now answer more than:

> What devices are on my network?

It can begin answering:

> What changed?

> When did it change?

> How long has a device been unavailable?

> Is the network currently healthy?

> Is the monitoring system itself functioning?

The next stage introduces **GraphQL**, allowing you to explore an alternative API paradigm alongside the REST API you built in Stage 4.
