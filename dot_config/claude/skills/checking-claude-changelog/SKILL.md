---
name: checking-claude-changelog
description: Use when the user wants to know what changed in Claude Code since their installed version - "check the changelog", "what's new", "should I update", "anything interesting in the latest release". Fetches the upstream CHANGELOG.md, diffs it against the running version, and summarizes the highlights.
allowed-tools: Bash(~/.config/claude/skills/checking-claude-changelog/check-changelog.sh *)
---

# Checking the Claude Code changelog

Changelog entries newer than the installed version:

!`~/.config/claude/skills/checking-claude-changelog/check-changelog.sh`

## Flow

1. Read the header lines (`installed`, `latest`, `status`). If the status is `up to date`, say so in one line and stop.

2. Summarize the sections below the header as highlights. Do not repeat the list; condense it:
   - New features and behavior changes first, grouped across versions.
   - Then fixes that touch this user's setup: Linux/Fedora, tmux, zsh, MCP servers, plugins and skills, hooks, settings,
     Remote Control, subagents and workflows. Skip fixes for platforms the user does not use (Windows, macOS only, VS
     Code, JetBrains, Cloud/Bedrock/Vertex) unless they are severe.
   - Call out anything that changes defaults, permissions, or removes a feature, since those are the update risks.

3. End with a one-line recommendation: update now, update but note X, or wait (for example, when the newest release is a
   regression fix for the release before it, or when a known regression is listed without a fix yet).

## Options

- `--since X.Y.Z` compares against a given version instead of the installed one.
- `--all` prints the full changelog; only use it when the user asks about an older release.

Run the script with these flags only when the user asks for a different range.

## When NOT to use

- Questions about how a Claude Code feature works: use the `claude-code-guide` agent instead.
- Changelogs of other projects: fetch them directly.
