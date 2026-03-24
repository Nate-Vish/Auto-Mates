---
name: slides
description: "Create presentations (PPTX or HTML slideshow) from content, research, or project files"
user_invocable: true
---

# /slides — Presentation Creator

Create professional presentations from any AutoMates content.

## How It Works

1. **Identify the content source** — ask the user what to turn into slides, or read from a specified file/folder in Work_Space/.

2. **Choose the format** — ask the user:
   - **PPTX** (PowerPoint) — uses the office-skills toolkit at `Tools/office-skills/`
   - **HTML** (browser slideshow) — self-contained HTML file, keyboard navigation, no dependencies

3. **Build the presentation:**

### For PPTX:
   - Read `Tools/office-skills/public/pptx/SKILL.md` COMPLETELY before starting
   - Follow the html2pptx workflow: design slides in HTML/CSS → render to PPTX
   - Use `Tools/office-skills/venv/bin/python` for all Python commands
   - Use the office-skills Node.js tools for HTML-to-PPTX conversion
   - Save output to `Tools/office-skills/outputs/<presentation-name>/`
   - Generate thumbnail grid for visual validation
   - If the pptx-server MCP is available, use its tools for direct PPTX creation

### For HTML:
   - Create a single self-contained HTML file with embedded CSS and JS
   - Dark professional theme (dark gray/black background, clean sans-serif font)
   - Keyboard navigation (arrow keys, spacebar)
   - Slide counter
   - Responsive design
   - Save to the same folder as the source content

4. **Validate** — check for text cutoff, layout issues, missing content.

5. **Deliver** — tell the user where the file is saved.

## Tips
- For product research → use HTML (includes images via URLs)
- For corporate/branded decks → use PPTX (template support)
- Always ask about the audience before designing
- Keep slides clean: one idea per slide, minimal text
- Use tables for comparisons, not bullet points

## Dependencies
- PPTX: `Tools/office-skills/` (venv + node_modules must be installed)
- HTML: No dependencies — works everywhere
- MCP: `pptx-server` (optional, for direct PPTX manipulation)
