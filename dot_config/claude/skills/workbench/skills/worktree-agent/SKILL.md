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

Close worktrees from the main checkout, never from inside the worktree being closed: closing ends the agent in it,
including this session if it runs there. Close when the user reports a merge, when an issue agent reports it is done,
or when the user asks to clean up.

```bash
worktree-agent close 708            # removes the worktree and its herdr workspace, ending its agent
worktree-agent prune                # lists worktrees whose MR/PR is merged
worktree-agent prune --yes          # removes the clean ones with an idle or no agent
```

Ask the user before `close` or `prune --yes`. Both delete a branch only when nothing is lost (a merged MR/PR, or no
commits of its own), and keep it otherwise. `close` refuses a worktree with uncommitted changes or a working or blocked
agent; pass `--force` only when the user confirms that work can go. A closed Claude session stays resumable with
`claude --resume`.

`worktree-agent adopt` opens worktrees created outside herdr (under `.claude/worktrees/`) as herdr workspaces.
