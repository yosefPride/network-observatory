# 01 — Foundation

## Purpose

Establish the development environment and project foundations before building the Network Observatory itself.

By the end of this stage, the project should have a clean repository, a working Python environment, a basic application structure, and a set of small command-line utilities for interacting with the local system.

This stage is intentionally not about building the network scanner yet.

---

## Topics

* Linux filesystem
* Linux processes and basic system administration
* `nano`
* Bash scripting
* Regex
* Python environment management
* `pip`
* Git
* GitKraken
* GitLab

---

# 1. Project Setup

Create the initial project structure:

```text
network-observatory/
├── README.md
├── docs/
├── backend/
├── frontend/
├── scripts/
├── tests/
├── Dockerfile
├── docker-compose.yml
└── .gitignore
```

Keep the structure minimal. Additional directories should be introduced when the project requires them.

### Goals

* Establish the project repository.
* Create the documentation structure.
* Establish a Python development environment.
* Create the initial backend and frontend placeholders.
* Establish a consistent development workflow.

---

# 2. Linux Filesystem

Become comfortable navigating and manipulating the Linux filesystem from the terminal.

### Learn

* Files and directories
* Absolute vs relative paths
* Current directory
* Home directory
* Hidden files
* File permissions
* Ownership
* Symbolic links
* Environment variables
* Standard input/output
* Pipes
* Redirection

### Commands to become comfortable with

```text
pwd
ls
cd
mkdir
touch
cp
mv
rm
find
cat
less
head
tail
grep
chmod
chown
ln
which
```

Do not simply memorize the commands. Understand what the operating system is doing when they are used.

### Practical exercise

Create and manipulate a small directory tree entirely from the terminal.

Then investigate:

* Which user owns the files?
* What permissions do they have?
* What happens when permissions are changed?
* Which files are hidden?
* Where are executable programs located?

---

# 3. Processes and Networking Basics

Before writing network software, understand what is happening on your own machine.

### Learn

* Process
* PID
* Parent/child processes
* Background processes
* Signals
* Ports
* Listening sockets
* localhost
* IP addresses
* Network interfaces

### Useful commands

```text
ps
top
htop
kill
ip
ss
ping
hostname
```

### Practical exercise

Find a process running on your machine and investigate:

1. Its PID
2. Which user owns it
3. Which network ports it is listening on
4. What happens when the process is terminated

The goal is to develop an intuition for the relationship between:

```text
process
    ↓
socket
    ↓
port
    ↓
network connection
```

This knowledge will become important in the network-discovery stage.

---

# 4. nano

Use `nano` for simple terminal-based editing.

Practice:

* Opening a file
* Editing text
* Searching
* Saving
* Exiting
* Working with multiple files

You do not need to become an advanced `nano` user. The goal is simply to be comfortable editing files from a terminal-only environment.

---

# 5. Bash

Create small Bash scripts in:

```text
scripts/
```

Start with simple scripts and progressively introduce more functionality.

### Concepts

Learn:

* Shebang
* Variables
* Arguments
* Exit status
* `if`
* `case`
* `for`
* `while`
* Functions
* Command substitution
* Pipes
* Redirection
* Quoting
* Environment variables

### Exercises

Create scripts that:

1. Print system information.
2. List currently running processes.
3. Display network interfaces.
4. Display listening ports.
5. Accept an argument and operate on it.
6. Return different exit codes depending on success/failure.
7. Combine several commands into a diagnostic report.

The scripts should be small. Their purpose is to learn Bash, not to become part of the final application.

---

# 6. Regex

Learn regular expressions as a tool for identifying patterns in text.

### Learn

* Literals
* Character classes
* Quantifiers
* Anchors
* Groups
* Alternation
* Capturing groups
* Escaping

Practice using regex with command-line tools such as:

```text
grep
```

and with Python.

### Exercises

Create patterns capable of identifying:

* IPv4 addresses
* MAC addresses
* Port numbers
* Log levels
* Simple timestamps
* Hostnames

Do not attempt to create a perfect IPv4/MAC validator at this stage.

The purpose is to understand pattern matching and how regex can be used when processing textual data.

---

# 7. Python Environment

Set up an isolated Python environment for the backend.

Learn:

* Python installation
* `venv`
* Virtual environments
* `pip`
* Installing packages
* Requirements files
* Python module paths

The project should use a dedicated virtual environment rather than the system Python environment.

### Goals

You should understand:

```text
system Python
      │
      ├── project A environment
      │
      └── Network Observatory environment
```

and why isolated environments are useful.

---

# 8. Git

Initialize the project as a Git repository.

Establish the basic workflow:

```text
working directory
       ↓
staging area
       ↓
commit
       ↓
branch
       ↓
remote repository
```

### Learn

* Repository
* Working tree
* Staging area
* Commit
* Branch
* Merge
* Remote
* Fetch
* Pull
* Push
* `.gitignore`
* Tags
* Commit history

### Initial workflow

Create:

```text
main
dev
```

Use `dev` as the primary development branch initially.

Feature work should eventually use feature branches.

### Git exercises

Practice:

1. Creating commits.
2. Viewing history.
3. Creating branches.
4. Merging branches.
5. Creating and resolving a merge conflict.
6. Reverting a commit.
7. Creating a tag.
8. Working with a remote repository.

---

# 9. GitKraken

Use GitKraken as a visual interface for the Git repository.

The goal is not to learn GitKraken instead of Git.

You should understand the Git operation being performed underneath the UI.

Use it to inspect:

* Branches
* Commits
* Merges
* Remotes
* Tags
* Repository history

Whenever possible, perform an operation using the command line first, then inspect the resulting state in GitKraken.

---

# 10. GitLab

Create the project's remote repository on GitLab.

Establish:

```text
local repository
       ↓
GitLab remote
```

Practice:

* Pushing branches
* Pulling changes
* Viewing commits
* Creating merge requests
* Reviewing changes
* Merging a feature branch

GitLab will eventually also be used for CI/CD, but that is outside the scope of this stage.

---

# 11. Initial Backend

Create the smallest possible Python backend structure.

```text
backend/
└── app/
    └── main.py
```

Do not build the API yet.

The objective is only to establish the location where the backend will live.

FastAPI and Uvicorn will be introduced in the API stage.

---

# 12. Initial Frontend

Create the initial frontend structure:

```text
frontend/
├── index.html
├── css/
│   └── style.css
└── js/
    └── main.js
```

Create a minimal HTML page and verify that it can be opened in a browser.

Do not build the application interface yet.

---

# 13. Documentation

Maintain your own notes while completing this stage.

Record concepts that were unclear, commands you learned, and problems you encountered.

Suggested file:

```text
docs/notes/
└── foundation-notes.md
```

The notes do not need to be polished.

The purpose is to create a personal reference that reflects what you actually learned.

---

# Completion Criteria

Do not move to Stage 2 until you can comfortably:

* Navigate the Linux filesystem from the terminal.
* Explain basic Linux file permissions.
* Find and inspect running processes.
* Identify listening ports on your machine.
* Write simple Bash scripts.
* Use pipes and redirection.
* Explain what an exit status is.
* Write basic regex patterns.
* Create and use a Python virtual environment.
* Install Python packages with `pip`.
* Explain Git's working tree, staging area, and repository.
* Create, merge, and resolve conflicts between branches.
* Push a repository to GitLab.
* Understand what GitKraken is showing you.
* Explain the difference between a local repository and a remote repository.

You do **not** need to memorize every command.

You should instead be capable of solving basic problems by consulting `man` pages, `--help`, documentation, or other references.

---

# Result

At the end of this stage, you should have:

```text
network-observatory/
├── README.md
├── docs/
│   ├── 01-foundation.md
│   └── notes/
│       └── foundation-notes.md
├── backend/
│   └── app/
│       └── main.py
├── frontend/
│   ├── index.html
│   ├── css/
│   │   └── style.css
│   └── js/
│       └── main.js
├── scripts/
├── tests/
├── Dockerfile
├── docker-compose.yml
└── .gitignore
```

The repository is under version control, hosted remotely, and ready for Stage 2.

The actual Network Observatory has not been built yet.

That begins with **network discovery**.
