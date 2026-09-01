# 02 — Network Discovery

## Purpose

Build the first functional component of Network Observatory: a command-line network discovery engine.

The system should be able to inspect a local network, discover reachable devices, collect basic information about them, and present the results in a useful format.

At the end of this stage, Network Observatory should be able to perform a scan from the command line and produce a structured representation of the discovered network.

The results do not need to be persisted yet. Persistence is introduced in Stage 3.

---

# Objectives

By the end of this stage, understand and implement:

* IPv4 addressing
* Subnets and CIDR notation
* Network interfaces
* ARP
* ICMP
* TCP
* UDP
* Ports
* Sockets
* Host discovery
* Service discovery
* Python networking
* Python concurrency
* Timeouts
* Error handling
* Structured application data
* CLI interaction

The goal is not to build a professional network scanner.

The goal is to understand the fundamental mechanisms involved in discovering and observing a network.

---

# 1. Network Fundamentals

Before writing the scanner, understand the basic concepts it will operate on.

## Learn

### IP addresses

Understand:

* IPv4 addresses
* Private address ranges
* Public addresses
* Loopback
* Network address
* Broadcast address
* Host address

Be able to explain the difference between:

```text
127.0.0.1
192.168.1.1
192.168.1.25
8.8.8.8
```

---

## Subnets

Learn:

* Subnet masks
* CIDR notation
* Network prefix
* Host portion
* Broadcast address
* Number of usable addresses

You should be able to look at:

```text
192.168.1.0/24
```

and determine what address range it represents.

Do not rely on a library to hide this concept from you.

---

## Network Interfaces

Investigate your own machine.

Determine:

* Which interfaces exist
* Which interface is connected to your local network
* Its IP address
* Its subnet
* Its MAC address

Use Linux tools to verify your understanding.

---

# 2. ARP

Learn what ARP does and why it matters to local-network discovery.

Understand the relationship between:

```text
IP address
    ↓
ARP
    ↓
MAC address
```

Investigate your machine's ARP/neighbour table.

Determine:

* Which devices are currently known
* Their IP addresses
* Their MAC addresses
* How the entries were learned

Understand that ARP is primarily relevant to local IPv4 networks.

---

# 3. Host Discovery

Build the first version of the scanner.

Its job is simply:

> Given a network range, determine which addresses appear to have a reachable host.

For example:

```text
network-observatory scan 192.168.1.0/24
```

The first implementation can use a straightforward reachability test.

Possible approaches to investigate include:

* ICMP
* TCP connection attempts
* ARP/neighbour discovery

Do not immediately choose an implementation because a tutorial tells you to.

Understand the strengths and limitations of each approach first.

---

# 4. Python Representation

Represent discovered devices using Python data structures.

A discovered device should eventually contain information such as:

```text
IP address
MAC address
hostname
status
discovery time
```

Do not worry about the final database model yet.

At this stage, the representation exists only in memory.

The important distinction is:

```text
network observation
        ↓
Python object
```

rather than:

```text
network observation
        ↓
database
```

Persistence comes later.

---

# 5. Scanner Architecture

Avoid putting the entire scanner into one function.

The exact architecture is your decision, but the system should have clear responsibilities.

Conceptually:

```text
Input
  ↓
Network calculation
  ↓
Host discovery
  ↓
Device information
  ↓
Result aggregation
  ↓
Output
```

The implementation should allow individual pieces to be tested independently.

For example, calculating the addresses in a subnet should not require performing an actual network scan.

---

# 6. Timeouts and Failures

Network operations are fundamentally unreliable.

A device may:

* Not exist
* Be offline
* Ignore a request
* Reject a connection
* Respond slowly
* Become unavailable during a scan
* Have a firewall blocking the probe

Your scanner must not hang indefinitely because one address doesn't respond.

Learn and implement:

* Timeouts
* Exception handling
* Failed probes
* Partial results

A failed probe should be treated as a normal possibility rather than an unexpected application crash.

---

# 7. Concurrency

A sequential scan of a large network can be unnecessarily slow.

For example:

```text
Host 1 → wait
Host 2 → wait
Host 3 → wait
Host 4 → wait
```

Investigate how concurrent execution can instead allow multiple probes to be in progress:

```text
Host 1 ────────┐
Host 2 ────────┤
Host 3 ────────┤──→ results
Host 4 ────────┘
```

Study the relevant Python approaches and determine which is appropriate for network-bound work.

You should understand:

* Blocking I/O
* Non-blocking I/O
* `asyncio`
* Tasks
* Concurrency vs parallelism
* Timeouts
* Limiting concurrency

Do not simply maximize the number of concurrent probes.

The scanner should behave predictably and avoid overwhelming the network.

---

# 8. Service Discovery

Once host discovery works, extend the scanner to investigate services.

Given a discovered host, determine whether selected TCP ports are reachable.

For example:

```text
22
80
443
8080
```

The scanner should produce information such as:

```text
192.168.1.20
    22   open
    80   open
    443  closed
```

Start with a small, explicit set of ports.

Do not attempt to scan every possible port.

The purpose of this stage is to understand:

```text
host discovery
        ↓
service discovery
        ↓
TCP connection
        ↓
port state
```

---

# 9. Hostnames

Investigate how an IP address can be associated with a hostname.

Explore:

* Local hostname resolution
* Reverse DNS
* `/etc/hosts`
* DNS
* mDNS where applicable

The scanner should attempt to obtain a hostname when possible, but failure to resolve a hostname should not cause the scan to fail.

---

# 10. CLI

Create a command-line interface for the scanner.

The exact interface is up to you.

It should eventually support operations conceptually similar to:

```text
network-observatory scan
network-observatory scan <network>
network-observatory devices
network-observatory services <device>
```

At this stage, only the scanning functionality needs to exist.

The CLI should:

* Accept input
* Validate input
* Start a scan
* Display progress where appropriate
* Display results
* Return an appropriate exit status

---

# 11. Output

Initially, provide human-readable output.

For example:

```text
Network: 192.168.1.0/24

Discovered devices:

192.168.1.1    router
192.168.1.10   desktop
192.168.1.20   server

3 devices discovered.
```

For services:

```text
192.168.1.20

Open services:
22     SSH
80     HTTP
```

The exact formatting is not important.

What matters is that the output clearly represents the underlying data.

---

# 12. Structured Output

Add a machine-readable output format.

For example:

```text
network-observatory scan --format json
```

The output should contain structured information about the scan and its results.

This will become useful later when the scanner is integrated with the API.

The important architectural transition is:

```text
Scanner
   ↓
structured data
   ↓
human-readable output
```

rather than having the scanner itself produce only formatted text.

---

# 13. Logging

Introduce basic logging into the scanner.

Log important events such as:

```text
scan started
scan completed
host discovered
probe failed
service discovered
```

Do not turn the terminal output into a wall of logs.

Keep user-facing output separate from diagnostic logging.

This distinction will become increasingly important as the application grows.

---

# 14. Regex

Use regex where it is appropriate for processing textual network information.

Potential uses include:

* Parsing command output
* Extracting IP addresses
* Extracting MAC addresses
* Processing hostnames
* Processing log output

Do not use regex for something that has a proper parser or structured API available.

The objective is to learn when regex is appropriate, not to force regex into the project.

---

# 15. Testing

Create tests for the parts of the scanner that can be tested without touching the network.

Examples:

### Network calculations

Given:

```text
192.168.1.0/30
```

verify that the expected addresses are produced.

### Input validation

Test:

```text
valid CIDR
invalid CIDR
invalid IP
invalid port
invalid range
```

### Result processing

Given simulated scan results, verify that they are correctly transformed into device/service objects.

### Failure handling

Simulate:

```text
timeout
connection failure
invalid response
```

and verify that the scanner handles them correctly.

---

# 16. Manual Testing

In addition to automated tests, test against your own network.

Use devices you own or are authorized to test.

Verify the scanner against known devices.

For example:

```text
Your computer
Router
Another computer
Phone
Local server
Docker container
```

Compare the scanner's results with information obtained through Linux networking tools.

The purpose is to establish whether your implementation corresponds to reality.

---

# 17. Milestones

Build the stage incrementally.

## Milestone 1 — Single Host

Given one IP address:

```text
192.168.1.10
```

determine whether a host appears reachable.

---

## Milestone 2 — Network

Given:

```text
192.168.1.0/24
```

discover reachable hosts.

---

## Milestone 3 — Device Information

For discovered hosts, collect additional information where available:

```text
IP
MAC
hostname
```

---

## Milestone 4 — Concurrency

Improve scanning performance by performing network-bound operations concurrently.

---

## Milestone 5 — Service Discovery

Determine whether selected TCP ports are reachable.

---

## Milestone 6 — CLI

Expose scanning functionality through the command line.

---

## Milestone 7 — Structured Results

Produce structured scan results suitable for later consumption by other components.

---

## Milestone 8 — Testing and Reliability

Add automated tests, timeouts, error handling, and logging.

---

# Completion Criteria

Stage 2 is complete when you can run a command that performs a network scan and produces structured results similar to:

```text
Scan
├── Network
│   └── 192.168.1.0/24
│
├── Devices
│   ├── Device
│   │   ├── IP
│   │   ├── MAC
│   │   ├── Hostname
│   │   └── Status
│   │
│   └── ...
│
└── Services
    ├── Device
    │   ├── Port
    │   ├── Protocol
    │   └── State
    │
    └── ...
```

You should also be able to explain:

* What an IP address represents.
* What a subnet represents.
* How CIDR notation works.
* What ARP does.
* How a host can be discovered.
* What a port represents.
* How TCP connection attempts can be used for service discovery.
* Why network operations require timeouts.
* Why concurrency improves network-bound workloads.
* The difference between concurrency and parallelism.
* Why a firewall can make "host is unreachable" different from "host does not exist."
* How your scanner obtains each piece of information it reports.

---

# Result

At the end of this stage:

```text
network-observatory/
├── backend/
│   └── app/
├── scripts/
│   └── ...
├── tests/
│   └── ...
└── docs/
    ├── 01-foundation.md
    └── 02-network-discovery.md
```

The project has its first real capability:

```text
Local Network
      ↓
Network Discovery Engine
      ↓
Structured Results
      ↓
CLI
```

No database, web API, frontend, authentication, or Kubernetes is required yet.

Those components will be built around this discovery engine in later stages.
