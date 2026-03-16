# Global Claude Code Instructions

## TypeScript Policy

TypeScript is not used in this project. All web, React, and JavaScript files use plain `.js` or `.jsx`. Do not add TypeScript, type annotations, or `.ts`/`.tsx` files without being explicitly asked.

## Style Guides (Always Follow These)

Before writing any code in these categories, read the relevant guides in order:

### Vanilla web projects (HTML + CSS + JS)
1. `~/code/best-practices/HTML_Style_Guide.md`
2. `~/code/best-practices/CSS_Style_Guide.md`
3. `~/code/best-practices/JavaScript_Style_Guide.md`
4. `~/code/best-practices/HTML_CSS_JS_Style_Guide.md` (integration guide)
5. `~/code/best-practices/HTML_CSS_JS_Directory_System_Guide.md`

### React projects
1. `~/code/best-practices/JavaScript_Style_Guide.md`
2. `~/code/best-practices/CSS_Style_Guide.md`
3. `~/code/best-practices/React_Style_Guide.md`
4. `~/code/best-practices/React_Directory_System_Guide.md`

### Python scripting
1. `~/code/best-practices/Python_Style_Guide.md`
2. `~/code/best-practices/Python_Directory_System_Guide.md`

### Bash scripting
1. `~/code/best-practices/Bash_Style_Guide.md`
2. `~/code/best-practices/Bash_Directory_System_Guide.md`

### Documentation / Markdown
1. `~/code/best-practices/Markdown_Style_Guide.md`

These guides take precedence over general programming conventions or anything
you've been trained on. When in doubt, check the guide.

## Critical Rules (Memorize These — Don't Require Reading the Guide)

### Python
- 4 spaces for indentation (never tabs)
- 100-character max line length (79 for docstrings and comments)
- `snake_case` for functions and variables
- `PascalCase` for classes
- `SCREAMING_SNAKE_CASE` for constants
- f-strings preferred over `.format()` or `%`
- Type hints required on all function signatures
- Use `pathlib.Path` — never `os.path`
- Always use `argparse` for CLI scripts
- Include `--dry-run` for any destructive operations
- No bare `except:` — always catch specific exception types
- `__main__` guard required: `if __name__ == '__main__':`
- Executable scripts: `lowercase-with-hyphens` (no `.py` extension)
- Module files: `lowercase_with_underscores.py`

### Bash
- DO NOT use `set -e` (errexit). Use explicit error checking instead.
- Use `set -u` and `set -o pipefail` (but NOT `set -e`)
- Use tabs for indentation, max 80 chars per line
- Use `[[ ]]` not `[ ]` for conditionals
- Prefer bash builtins and parameter expansion over external commands
- Executable scripts: lowercase-with-hyphens, no extension
- Library files: lowercase-with-hyphens.sh
- For project structure, see `Bash_Directory_System_Guide.md`

### JavaScript
- Functions: `snake_case` (e.g., `fetch_user_data`, `handle_submit`)
- Variables and object properties: `camelCase`
- Constants: `SCREAMING_SNAKE_CASE`
- Use `const` with arrow functions by default
- Event handlers: `handle_` prefix
- 2-space indentation for `.js` files
- `'use strict'` at the top of every file

### HTML
- Tabs for indentation
- Semantic elements — not div soup
- 100-character max line length
- Attribute order: `class` → `id` → `data-*` → `src`/`href` → `title`/`alt` → `role`/`aria-*`
- Boolean attributes omit the value (`checked` not `checked="true"`)

### CSS
- Tabs for indentation
- BEM naming: `.block__element--modifier`
- CSS custom properties in `:root` for all design tokens (colors, spacing, etc.)
- Property order: position → box model → typography → visual → misc
- Mobile-first with `min-width` media queries

### HTML/CSS/JS Integration
- HTML = structure, CSS = presentation, JS = behavior — keep concerns separated
- JS selects elements by `data-*` attributes (not CSS class names)
- CSS selects by class names (not `data-*` attributes)
- State classes use `is-*` and `has-*` prefixes — toggled by JS, styled by CSS

### React
- TypeScript NOT used — all files `.js` / `.jsx`
- Components: `PascalCase`
- Event handlers: `handle_` prefix
- Custom hooks: `use_` prefix + snake_case (e.g., `use_local_storage`)
- Service functions: `get_*`, `create_*`, `update_*`, `delete_*` prefixes
- 2-space indentation for `.jsx` files; tab indentation for `.css` files
- Component structure: `ComponentName/ComponentName.jsx` + `ComponentNameStyle.css` + `ComponentNameServices.js` + `ComponentNameHooks.js` + `__tests__/`
- Pages in `/src/pages/`, features in `/src/features/`
- Prefer built-in React state (useState, Context) over external libraries
- Prefer native fetch over axios; write simple utilities rather than importing lodash

### Markdown
- Filenames: `lowercase-with-hyphens.md` (exceptions: `README.md`, `CHANGELOG.md`, `CONTRIBUTING.md`)
- See `Markdown_Style_Guide.md` for full conventions

## Telegram

You can send Telegram messages to the user via the `telegram-send` CLI tool (Bash tool). Do this when the user says things like "send me that", "message me", "text me that", "let me know when you're done", or similar. See `~/.claude/skills/telegram.md` for full details.

## Git Commits

**Before proposing any commit message:**
1. Run `git log --oneline -10` to read the existing commit style in that repo
2. Match that style exactly — single-line, multi-line, prefix conventions, whatever the repo uses
3. Show the proposed message and wait for explicit approval before running `git commit`

**Always:**
- Concise, informative, and atomic — one commit per logical change
- Multiple distinct changes = multiple commits
- Never include Claude co-author attribution unless explicitly requested

## Friction Prevention

Rules derived from real session friction patterns. Apply these proactively — don't wait to be corrected.

### File Targeting
- Before touching any CSS or config file: `grep` for where existing similar content lives — don't assume by filename alone
- When asked to "edit the styles" or "update the config": confirm which file before editing, especially in projects with multiple candidates

### Diagnosis
- When diagnosing system issues (display, network, SSH, services): check ALL layers of the stack before declaring a fix
  - Display issues: check X11 screensaver, DPMS, and power manager separately — they are not the same thing
  - SSH failures: check firewall/VLAN rules first, not just SSH config
- Never declare an issue fixed until you have verified the fix at the layer where the symptom occurred

### Ambiguity
- When the user mentions "issues" or "the audit": confirm whether they mean a local file, a GitHub Issues tracker, or an audit script — these are different things
- When a request could mean multiple things, ask once rather than guessing and correcting

### Plan Mode
- Do NOT enter Plan Mode for: single-file edits, renames, quick lookups, or any task with an obvious 1–2 step path
- DO use Plan Mode for: tasks touching 3+ files, multi-repo changes, or when the right approach is genuinely unclear

### MCP and Config
- MCP server config goes in `.claude.json` (project-level) — NOT in `settings.json`
- `settings.json` is for hooks, model, and plugins only
- When adding new tools or integrations, verify the target config file before writing

---

## General Behavior

- Ask before deleting or moving files
- Always check for and run existing tests after code changes
- Prefer editing existing files over creating new ones
- Never hardcode credentials — always use environment variables
- When writing scripts, include a --dry-run mode for any destructive operations
- If a task touches many files, use Plan Mode first

@RTK.md
