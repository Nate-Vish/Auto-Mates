# Lessons Learned - Builder

*Mistakes to avoid, patterns that worked*

---

## 2026-02-03 - Claude Code Identity Loading
- **Context:** 4 failed attempts to load agent identities via /summon skill
- **Lesson:** To make Claude act as an agent with auto-startup:
  1. Use `--append-system-prompt` (not `--system-prompt`)
  2. Include FULL identity content (not just path)
  3. Add explicit STARTUP INSTRUCTION telling Claude to execute protocol NOW
  4. Don't pipe to stdin - breaks interactive mode
  5. Use temp launcher scripts to handle special characters
- **Apply when:** Building any skill that needs Claude to adopt a persona and act immediately

## 2026-02-03 - Bash 3.2 Compatibility
- **Context:** macOS ships with Bash 3.2, which doesn't support associative arrays (`declare -A`)
- **Lesson:** Use case statements instead of associative arrays for Bash 3.2 compatibility
- **Apply when:** Writing shell scripts that must run on macOS

---

<!-- Template for new entries:

## [YYYY-MM-DD] - [Brief title]
- **Context:** [what happened]
- **Lesson:** [what to remember]
- **Apply when:** [future trigger]

-->
