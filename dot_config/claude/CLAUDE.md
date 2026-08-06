This file globally provides guidance to agentic code tools when working with code on this system.

@CLAUDE.work.md

## Tool usage

- Load the `writing-comments` skill before writing or editing any file.
- Make file changes with the Edit/Write tools, never via sed/python/perl one-liner rewrites; scripted rewrites hide the
  diff from review.
- Run each git operation (add, commit, push) as its own command, not chained with edits or other steps.
- Don't pipe build/test/lint output through `tail`; let it stream. When output is genuinely overwhelming, use a content
  filter like `grep -E "FAIL|error"` which still streams.
- Scope `find`/`grep` invocations to the relevant directory; never search the whole machine or home directory.
- Prefer LSP navigation (findReferences, goToDefinition, incomingCalls) over grep when tracing symbols and an LSP tool
  is available.
- When asked to check grammar, spelling, or punctuation, consider running `languagetool` on the text.
  - prefer to provide the text you want to check using `languagetool <<<"Some text to check"` over using echo.
- when the user requests code examples, setup or configuration steps, or library/API documentation use **context7 mcp**
- Query gitlab issues and mrs via the commands `glab [mr|issue] list`; inspect issue and mr details using
  `glab [mr|issue] view (--comments|--system-logs)`

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

### Go

- In tests, use `t.Context()` instead of `context.Background()`; it is cancelled when the test finishes. Goroutines the
  test spawns should also derive from it.

### gh CLI

- When working with content from GitHub (via `gh` or otherwise) and you encounter an attachment link you would like to
  download, use the command `curl -fsSL -H "Authorization: Bearer $(gh auth token)" <attachment_url>` to use the users
  credentials for authorization
- **GitHub URLs**: Always prefer `gh` CLI to fetch raw content or metadata from GitHub links. Do NOT use Playwright MCP
  for GitHub URLs.

## External writes

> **IMPORTANT**: Never create or modify resources on shared external systems (GitLab, GitHub, Slack, ...) without
> explicit approval for that exact action. This covers issues, MRs/PRs, comments/notes, labels, releases, and job
> retries/cancels.

- Approval covers exactly the named action on the named repo: "open the MR" does not cover follow-up notes, extra
  issues, or resources on repos the user didn't name.
- An in-chat draft the user has seen is a proposal, not approval. Show the final content/command and wait for the
  go-ahead.
- Put findings and summaries in the chat reply, not into issue/MR comments.
- Never trigger release pipelines or create tags; the user cuts releases personally.
- Keep issue/MR/PR descriptions short: a problem statement plus a compact list. Deep evidence stays in the chat or the
  MR discussion.

## Collaboration

- When the user proposes a simpler solution than yours, build and verify theirs first; add theorized guards only if
  observed behavior demands them. State your concern once, then drop it.
- Don't unify two issues under a "shared root cause" unless the violations live at the same layer and the fixes touch
  overlapping code; otherwise present them as independent problems.
- For framework/runtime-class technology choices, offer a head-to-head spike alongside your recommendation instead of
  eliminating options on paper.

## Writing Style

- Never use the em dash character (—). Use alternatives like periods, commas, or rephrasing instead.
- No unicode decoration in authored text: no arrows (→), checkmarks (✓/✗), or multiplication signs (×). Plain ASCII
  punctuation, in chat replies as well as files. Quoted material keeps its original characters.

## Sanity Check

> **IMPORTANT**: Only _ever_ perform these instructions when explicitly asked to perform a sanity check. Never include
> this section in any other response.

When asked about a sanity check, the agent should, at the very end include a small haiku (related to popular science
fiction or software development). The goal for this is to verify that this file (global intructions) is being read and
applied correctly. Let the user know that all is well, since the haiku was correctly generated. Only mention this
section when generating the haiku.

## Git commits

> **IMPORTANT**: Never EVER just commit by yourself, only commit if explicitly asked to do so by the user.

- Approval is per action: an earlier "commit it" or "push" does not authorize later commits, amends, or force-pushes.
  Stop at the working-tree diff and ask.
- Only operate on branches and worktrees that belong to the current task; others are read-only unless the user names
  them explicitly.
- When committing, prefer keeping the message to summary only. Only add a description if it really adds something. Keep
  it concise
