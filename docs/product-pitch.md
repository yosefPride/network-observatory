# Network Observatory — Product Summary

A self-hosted tool for discovering, tracking, and continuously monitoring the devices and
services on a local network, with a browser interface, a command line, and a programmable API.

This document describes what the finished system will be able to do. It is a summary of the
capabilities defined across the stage documents `01`–`11`, not a description of how they are built.

---

## What it does

Network Observatory answers four questions about a local network:

1. **What is on my network right now?**
2. **What is each device running?**
3. **What has changed, and when?**
4. **Is anything currently unavailable — and can I trust that answer?**

---

## Capabilities

### Discovery

* Scan a network range and determine which addresses have a reachable host.
* Collect identifying information for each discovered device: IP address, hardware (MAC)
  address, and hostname where it can be resolved.
* Probe a configured set of TCP ports on discovered devices to determine which services are
  reachable, and report each port's state.
* Complete a scan reliably in the presence of unresponsive, slow, filtered, or firewalled
  hosts — a failed probe is a result, not a crash.
* Report a scan's own performance: duration, hosts scanned, hosts found, errors encountered.

### Tracking over time

* Recognize a previously seen device across scans rather than treating every scan as a new
  network.
* Retain the full observation history of a device instead of overwriting its last known state.
* Compare consecutive scans and detect meaningful changes: a device appearing, disappearing, or
  returning; a hostname or hardware address changing; a service appearing, disappearing, or
  changing state.
* Record each detected change as a timestamped event that can be queried by device or by time
  range.

### Continuous monitoring

* Monitor a configured network automatically on a repeating interval, without a user
  initiating each scan.
* Track device availability over time and report current status, last seen, last state change,
  and uptime over a defined period.
* Distinguish "the device is unavailable" from "the monitoring system failed to observe it,"
  and surface the monitoring system's own state — last successful scan, last failure,
  consecutive failures, whether a scan is running now.
* Recover from temporary failures (an unreachable network, an unavailable dependency, a
  restart) and resume monitoring without manual intervention.
* Report its own health, so an operator can tell whether the system is running and whether
  everything it depends on is reachable.

### Access and accounts

* Support user accounts with credentials that can be registered and authenticated.
* Issue time-limited session credentials, and require them on protected operations.
* Separate *who you are* from *what you may do*: permissions distinguish users who can view the
  network from users who can also change its configuration or start scans.
* Refuse unauthenticated and unauthorized requests distinguishably, without leaking internal
  detail.

### Interfaces

The same underlying functionality is reachable four ways:

* **Command line** — run a scan against a given network and print results for a human, or emit
  structured machine-readable output for another program.
* **Web interface** — log in and browse a dashboard summarizing the network, a device list,
  per-device detail with services and history, an event timeline, and a scan view; start scans
  and watch their progress. Usable across desktop, tablet, and mobile viewports, and
  keyboard-accessible.
* **REST API** — retrieve devices, services, scans, events, availability, and monitoring status;
  start scans; filter and page through collections. Self-describing, so any HTTP client can
  discover and use it.
* **GraphQL API** — request exactly the fields and related data a client needs in a single
  query, including nested device → service → event data, alongside the same state-changing
  operations. Both APIs are views onto one application, not two separate products.

### Operation

* Configurable without editing source: which network to monitor, how often, which ports to
  check, and whether monitoring is active.
* Runs as a self-contained, reproducible package — an operator can bring up the complete system
  on a clean machine without installing its dependencies by hand.
* Deployable as a managed workload that can be scaled, updated in place, health-checked, and
  rolled back to a previous version, with background monitoring work that does not duplicate
  itself when the application is scaled.
* Deployable through an automated pipeline in which every running version is traceable back to
  the exact source revision that produced it.
* Emits structured logs and operational metrics suitable for diagnosis, and deliberately keeps
  credentials and secrets out of them.

---

## Deliberate boundaries

The finished system is intentionally **not**:

* A security or vulnerability scanner. It observes reachability, not weaknesses, and checks a
  small explicit set of ports rather than sweeping all of them.
* An internet-scale or multi-site scanner. It observes a local network it is authorized to
  observe.
* A device management tool. It reports on devices; it does not configure or control them.
* An alerting or notification platform. It records and displays what changed; it does not page
  anyone.

---

## In one sentence

Network Observatory turns a local network from something you can only look at one moment at a
time into something with a memory: a continuously updated, queryable, historical record of every
device and service on it, and of when each one appeared, vanished, or changed.
