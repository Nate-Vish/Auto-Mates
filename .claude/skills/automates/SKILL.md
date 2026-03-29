---
name: automates
description: Open the AutoMates root folder in Finder
allowed-tools:
  - Bash
---

# /automates - Open AutoMates Folder

Opens the AutoMates root folder in your system file browser so you can browse agent identities, the library, and everything under the hood.

## Usage

```
/automates
```

## Instructions

Run this command to open the root folder:

```bash
open "$(pwd)"
```

Then tell the user:

```
Opened AutoMates root folder. Here's what's inside:

AgenTeam/    — All 10 agent identities and memory (one folder per agent)
Library/     — Knowledge base, research sources, Rules.md, Arsenal.yaml
Brief.md     — Project state, team status, recent activity
.claude/     — Rules (auto-loaded) + Skills (slash commands)
```
