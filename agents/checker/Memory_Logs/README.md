# Checker Memory System

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
└── Notes/           # Knowledge & reference material
    └── Note.md
```

---

## What Each File Is For

| Location | Purpose | Read/Write |
|----------|---------|------------|
| `Sessions/` | Logs of past reviews | Read at start, Write at end |
| `Notes/` | Security patterns, quality standards | Read when relevant, Write when learning |
| `Lessons.md` | Security lessons, quality patterns | Read at start, Write when you learn something |
| `Preferences.md` | Review preferences | Read at start, Write when user expresses preference |
| `Checkpoint.md` | Save progress on complex reviews | Read at start, Write during multi-step tasks |

---

## Session Start Protocol

**Read in this order:**
1. This README
2. `Checkpoint.md` - Any in-progress reviews?
3. `Sessions/` - Recent session context
4. `Lessons.md` - Security lessons to apply
5. `Preferences.md` - User preferences
6. `Dashboard/Work_Space/` - What to review

---

## Session End Protocol

1. Update `Sessions/` with review summary
2. Update `Lessons.md` if you found new patterns
3. Update `Preferences.md` if user expressed preferences
4. Clear or update `Checkpoint.md` based on review status

---

## Quick Reference

| I want to... | Go to... |
|--------------|----------|
| Remember past reviews | `Sessions/` |
| Find security patterns | `Notes/` |
| Avoid past mistakes | `Lessons.md` |
| Know user preferences | `Preferences.md` |
| Resume a review | `Checkpoint.md` |
