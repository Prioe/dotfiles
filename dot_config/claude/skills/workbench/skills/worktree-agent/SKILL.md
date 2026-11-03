---
name: worktree-agent
description: Start a separate coding agent for an issue or task in its own git worktree and herdr workspace, check on those agents, and clean up after a merge. Use when the user asks to start, work on, spin up, or dispatch an issue or task to a new agent or worktree, asks for the status of such agents, or wants a merged worktree removed. Do not use when the user wants the work done in the current session.
allowed-tools:
  - Bash(worktree-agent:*)
  - Bash(herdr agent list:*)
  - Bash(herdr agent read:*)
---

# Worktree agents

`worktree-agent` creates a git worktree as a herdr workspace, starts Claude in it, and sends the first prompt. herdr
then owns the agent: its state, notifications and session restore. Run it from the repository that should get the
change; `--cwd <path>` points it at another checkout.

## Start

```bash
worktree-agent start 708                        # issue of this repo (GitHub or GitLab, from origin)
worktree-agent start https://host/group/repo/-/issues/708
worktree-agent start "spike the qemu gui"       # free-text task, no issue
```

- Use `--no-focus` when the user keeps working here, and for each task when starting several. Start each task with its
  own call.
- Use `--dry-run` to show the branch, label, session name and prompt first when the request is ambiguous.
- `--no-agent` only creates the worktree. `--base <ref>` stacks the branch on another branch.
- If the worktree already has an agent, the script reports it and starts nothing.

After starting, report the label and branch the script printed. Do not also work on the task in this session.

## Check on agents

```bash
worktree-agent list                 # this repo's worktrees, their herdr workspace and agent state
herdr agent read <agent> --lines 40 # what an agent shows right now
```

To pass something on to an agent, show the user the exact text first, then send it with
`herdr agent prompt <agent> "<text>"`.

## Clean up

```bash
worktree-agent close 708            # removes the worktree and its herdr workspace, ending its agent
```

Ask the user before closing: it ends the agent in that worktree. The script deletes the branch only when a merged MR or
PR exists for it, and otherwise prints how to delete it. It refuses a worktree with uncommitted changes; pass `--force`
only when the user confirms the changes can go.

`worktree-agent adopt` opens worktrees created outside herdr (under `.claude/worktrees/`) as herdr workspaces.
