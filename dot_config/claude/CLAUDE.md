This file globally provides guidance to agentic code tools when working with code on this system.

## Tool usage

- When asked to check grammar, spelling, or punctuation, consider running `languagetool` on the text.
  - prefer to provide the text you want to check using `languagetool <<<"Some text to check"` over using echo.
- when the user requests code examples, setup or configuration steps, or library/API documentation use **context7 mcp**
- when the user requests to read documentation from an url, use the **playwright mcp** to fetch and parse the url

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

### gh CLI

- When working with content from GitHub (via `gh` or otherwise) and you encounter an attachment link you would like to
  download, use the command `curl -fsSL -H "Authorization: Bearer $(gh auth token)" <attachment_url>` to use the users
  credentials for authorization

## Sanity Check

> **IMPORTANT**: Only _ever_ perform these instructions when explicitly asked to perform a sanity check. Never include
> this section in any other response.

When asked about a sanity check, the agent should, at the very end include a small haiku (related to popular science
fiction or software development). The goal for this is to verify that this file (global intructions) is being read and
applied correctly. Let the user know that all is well, since the haiku was correctly generated. Only mention this
section when generating the haiku.

## Git commits

> **IMPORTANT**: Never EVER just commit by yourself, only commit if explicitly asked to do so by the user.
