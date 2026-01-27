# Orca Memory System

**Read this first to understand how to use your memory.**

---

## Structure

```
Memory_Logs/
├── README.md        ← You are here
├── Sessions/        # Past conversation logs
├── Notes/           # Knowledge & reference material
├── Lessons.md       # Wisdom from experience
├── Preferences.md   # User preferences
└── Checkpoint.md    # Save/resume complex tasks
```

---

## What Each File Is For

| Location | Purpose | Read/Write |
|----------|---------|------------|
| `Sessions/` | Logs of past conversations | Read at start, Write at end |
| `Notes/` | Knowledge files (agent design patterns, frameworks, etc.) | Read when relevant, Write when learning |
| `Lessons.md` | Hard-won wisdom, mistakes to avoid | Read at start, Write when you learn something |
| `Preferences.md` | How the user likes things done | Read at start, Write when user expresses preference |
| `Checkpoint.md` | Save progress on complex tasks | Read at start, Write during multi-step tasks |

---

## Session Start Protocol

**Read in this order:**
1. Identity file (you've done this)
2. This README (you're doing this)
3. `Checkpoint.md` - Any in-progress tasks?
4. `Sessions/` - Recent session context
5. `Lessons.md` - Wisdom to apply
6. `Preferences.md` - User preferences
7. `Current_Identities/README.md` - Agent registry
8. `Dashboard/Work_Space/Status.md` - Current project state
9. `Library/Sources/` - Research sources (if needed)

**Then:** If you need more knowledge, send a Knowledge Request to Fetcher.

---

## Session End Protocol

1. Update `Sessions/` with session summary
2. Update `Lessons.md` if you learned something
3. Update `Preferences.md` if user expressed preferences
4. Clear or update `Checkpoint.md` based on task status

---

## Format Templates

### Sessions Entry
```markdown
## [YYYY-MM-DD] - [Brief Title]
**Summary:** [What happened]
**Agents created/updated:** [List if any]
**Decisions:** [Key decisions made]
**Next:** [What to continue]
```

### Lessons Entry
```markdown
## [YYYY-MM-DD] - [Brief Title]
- **Context:** [What happened]
- **Lesson:** [What to remember]
- **Apply when:** [Future trigger]
```

### Preferences Entry
```markdown
## [Category]
- [YYYY-MM-DD]: [User preference]
```

### Checkpoint (Active Task)
```markdown
**Status:** In Progress
**Task:** [Description]
**Progress:**
- [x] Done step
- [ ] Current step ← HERE
- [ ] Future step
**Next Action:** [Exactly what to do next]
```

---

## Quick Reference

| I want to... | Go to... |
|--------------|----------|
| Remember past sessions | `Sessions/` |
| Find agent design patterns | `Notes/` |
| Avoid past mistakes | `Lessons.md` |
| Know user preferences | `Preferences.md` |
| Resume a task | `Checkpoint.md` |
| See all agents | `Current_Identities/README.md` |
| Output drafts | `Dashboard/Work_Space/` |
