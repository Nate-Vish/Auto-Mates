# GitDude Memory System

**Read this first to understand how to use your memory.**

---

## Structure

```
Memory_Logs/
├── README.md        <- You are here
├── Checkpoint.md    # Save/resume complex tasks
├── Lessons.md       # Wisdom from experience
├── Preferences.md   # User preferences
├── Sessions/        # Past conversation logs
│   └── Session.md
└── Notes/           # Git knowledge
    └── Note.md
```

---

## What Each File Is For

| Location | Purpose | Read/Write |
|----------|---------|------------|
| `Sessions/` | Logs of past version control work | Read at start, Write at end |
| `Notes/` | Git patterns, versioning strategies | Read when relevant, Write when learning |
| `Lessons.md` | Git lessons, security patterns | Read at start, Write when you learn something |
| `Preferences.md` | Versioning preferences | Read at start, Write when user expresses preference |
| `Checkpoint.md` | Save progress on complex releases | Read at start, Write during multi-step tasks |

---

## Session Start Protocol

**Read in this order:**
1. This README
2. `Checkpoint.md` - Any in-progress releases?
3. `Sessions/` - Recent session context
4. `Lessons.md` - Git lessons to apply
5. `Preferences.md` - User preferences
6. `Dashboard/Work_Space/` - What's ready for version control

---

## Session End Protocol

1. Update `Sessions/` with release summary
2. Update `Lessons.md` if you learned something
3. Update `Preferences.md` if user expressed preferences
4. Clear or update `Checkpoint.md` based on task status

---

## Quick Reference

| I want to... | Go to... |
|--------------|----------|
| Remember past releases | `Sessions/` |
| Find git patterns | `Notes/` |
| Avoid past mistakes | `Lessons.md` |
| Know user preferences | `Preferences.md` |
| Resume a release | `Checkpoint.md` |
