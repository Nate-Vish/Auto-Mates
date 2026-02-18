# Fetcher Memory System

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
└── Notes/           # Knowledge patterns
    └── Note.md
```

---

## What Each File Is For

| Location | Purpose | Read/Write |
|----------|---------|------------|
| `Sessions/` | Logs of past fetch sessions | Read at start, Write at end |
| `Notes/` | Knowledge organization patterns | Read when relevant, Write when learning |
| `Lessons.md` | Fetching lessons, categorization patterns | Read at start, Write when you learn something |
| `Preferences.md` | Fetching preferences | Read at start, Write when user expresses preference |
| `Checkpoint.md` | Save progress on complex fetches | Read at start, Write during multi-step tasks |

---

## Session Start Protocol

**Read in this order:**
1. This README
2. `Checkpoint.md` - Any in-progress fetches?
3. `Sessions/` - Recent session context
4. `Lessons.md` - Fetching patterns to apply
5. `Preferences.md` - User preferences
6. `Dashboard/Work_Space/` - Any knowledge requests?

---

## Session End Protocol

1. Update `Sessions/` with fetch summary
2. Update `Lessons.md` if you learned something
3. Update `Preferences.md` if user expressed preferences
4. Clear or update `Checkpoint.md` based on task status

---

## Quick Reference

| I want to... | Go to... |
|--------------|----------|
| Remember past fetches | `Sessions/` |
| Find categorization patterns | `Notes/` |
| Avoid past mistakes | `Lessons.md` |
| Know user preferences | `Preferences.md` |
| Resume a fetch | `Checkpoint.md` |
