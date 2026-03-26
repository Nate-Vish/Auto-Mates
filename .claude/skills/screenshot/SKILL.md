# /screenshot — Capture a Screenshot with Playwright

Take a screenshot of any URL or local HTML file using Playwright CLI.

## Usage

```
/screenshot <target>                    # Desktop viewport (1440x900)
/screenshot <target> mobile             # Mobile viewport (390x844)
/screenshot <target> full               # Full-page capture
/screenshot <target> mobile full        # Mobile + full-page
```

## Instructions

When invoked, run the appropriate Playwright command:

### 1. Determine the target
- If the target is a URL (starts with `http`), use it directly
- If the target is a file path, convert to `file://` URL (encode spaces as `%20`)
- If no target given, look for the most recently discussed HTML file in the conversation

### 2. Determine the viewport
- Default: `--viewport-size="1440,900"` (desktop)
- If `mobile` is specified: `--viewport-size="390,844"`

### 3. Determine capture mode
- Default: above-the-fold only (no `--full-page`)
- If `full` is specified: add `--full-page`

### 4. Take the screenshot

```bash
npx playwright screenshot [--viewport-size="WxH"] [--full-page] "<target>" /tmp/screenshot.png
```

### 5. Show the result

Read the screenshot file using the Read tool so it displays visually in the conversation.

### 6. Review

After showing the screenshot, provide a brief visual review noting any obvious layout issues (spacing, overflow, alignment, text wrapping, orphaned words).

## Examples

```
/screenshot docs/index.html
/screenshot https://automate-s.com full
/screenshot Landing_Page_Sunrise.html mobile
```

## Notes
- Playwright must be installed (`npx playwright install` if needed)
- Screenshots are saved to `/tmp/screenshot.png` (overwritten each time)
- The Read tool can display PNG files visually
- Works with any agent — designed for visual QA during brand, UI, and landing page work
