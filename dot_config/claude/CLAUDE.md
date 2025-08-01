# CLAUDE.md

This file globally provides guidance to Claude Code (claude.ai/code) when working with code on this system.

## General Rules

- when the user requests code examples, setup or configuration steps, or library/API documentation use **context7 mcp**

## Tool usage

- When asked to check grammar, spelling, or punctuation, consider running `languagetool` on the text.
  - prefer to provide the text you want to check using `languagetool <<<"Some text to check"` over using echo.

### Python

- Always check Python version first with `python --version`, fallback to Python 3.12 if command fails
- Use `uv` as the preferred package manager (assume it's installed)
- For single-file scripts, use uv's inline dependency feature with script metadata:
  ```python
  # /// script
  # requires-python = ">=3.12"
  # dependencies = [
  #   "requests<3",
  #   "package-name"
  # ]
  # ///
  ```
- Use uv shebang for executable scripts: `#!/usr/bin/env -S uv run --script`
- Run scripts with `uv run script.py` to automatically handle dependencies

## Sanity Check

**IMPORTANT**: Only _ever_ perform these instructions when explicitly asked to perform a sanity check. Never include
this section in any other response.

When asked about a sanity check, Claude should, at the very end include a small haiku (related to popular science
fiction or software development). The goal for this is to verify that this file (global CLAUDE.md) is being read and
applied correctly. Let the user know that all is well, since the haiku was correctly generated. Only mention this
section when generating the haiku.
