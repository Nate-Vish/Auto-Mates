# Version Control

*Production-ready releases managed by GitDude*

---

## What Is This?

This folder contains versioned snapshots of your project, prepared by **GitDude** when you're ready to release.

## How It Works

1. **You decide** a version is ready for release
2. **Activate GitDude** manually
3. **GitDude scans** for secrets and security issues
4. **GitDude prepares** the release in a versioned folder
5. **GitDude commits** to git (if configured)

## Folder Structure

```
Version_Control/
├── README.md          # This file
├── AM - v1.0/         # First release
├── AM - v1.1/         # Second release
└── ...
```

## Naming Convention

`AM - v[MAJOR].[MINOR]`

- **MAJOR:** Breaking changes or major milestones
- **MINOR:** New features, improvements, fixes

---

*GitDude is the gatekeeper. No code leaves without a security check.*
