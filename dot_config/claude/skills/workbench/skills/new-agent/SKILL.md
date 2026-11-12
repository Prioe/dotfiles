---
name: new-agent
description: Start a new agent in its own worktree from a free-text description of what it should do, or from an issue reference with optional extra context. Use when the user invokes /workbench:new-agent with a description, typically from a manager session.
argument-hint: <what the agent should do, or an issue like #12 plus context>
allowed-tools:
  - Bash(worktree-agent start:*)
---

# New agent

The user wants a new agent for this:

> $ARGUMENTS

If that is empty, ask what the agent should do and stop.

## Steps

1. **Find the repo.** Use this session's checkout. If the text clearly names another repo whose checkout path you know,
   pass `--cwd <path>`; if it names one you cannot place, ask.
2. **Issue or task.** If the text refers to an issue or MR/PR of this repo (`#12`, `12`, a URL), it is an issue. Any
   other text is a free-text task.
3. **Compose the call.**
   - Task: write a short name of 3 to 6 words, imperative and lowercase, for the branch and labels, such as
     `"spike xlsx export options"`. Pass the user's full text as the brief, unchanged.

     ```bash
     worktree-agent start --no-focus "<short name>" --brief "<user's text>"
     ```

   - Issue: pass the reference. If the text adds context beyond the reference, pass that part as the brief.

     ```bash
     worktree-agent start --no-focus <issue> [--brief "<extra context>"]
     ```

   - Add `--base <branch>` when the text says to build on another branch.
4. **Check first when unsure.** If the issue/task decision or the short name is a guess, run the same call with
   `--dry-run`, show the branch, label and first prompt, and wait for a yes.
5. **Start it** and report the workspace label, the branch, and that the agent got its prompt. Do not work on the task
   in this session.

The brief reaches the agent as written; a long or multi-line one is stored in a file the agent is told to read.
