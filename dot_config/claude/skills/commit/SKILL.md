---
name: commit
description: Create a git commit
argument-hint: last-task | staged | all
allowed-tools:
  - Bash(git status)
  - Bash(git diff)
  - Bash(git log)
  - Bash(git commit)
  - Bash(git add)
---

# Commit Changes

Create a git commit using conventional commit messages.

## Arguments

- `last-task`: Commit changes from the last completed task
- `staged`: Commit only already-staged changes
- `all`: Stage and commit all changes

Arguments provided by the user:

<arguments>
$ARGUMENTS
</arguments>

## Workflow

1. Review the context below (status, log, diff)
2. Stage the correct files based on the argument
3. Generate 3 conventional commit message candidates
4. Auto-select the best message and explain your choice briefly
5. Commit with the selected message
6. Show the resulting commit hash and message

## Guidelines

- No commit body unless the user specifically requests one
- Stage only the files appropriate for the given argument
- If no argument is given, default to `staged`
- Use a HEREDOC to pass the commit message to `git commit -m`

## Conventional Commits Format

Language: en-US. Format: `type(scope): description`

### Types

| Type | Purpose |
|------|---------|
| feat | New feature (MINOR bump) |
| fix | Bug fix (PATCH bump) |
| docs | Documentation only |
| style | Formatting, no logic change |
| refactor | Neither fix nor feature |
| perf | Performance improvement |
| test | Adding or correcting tests |
| build | Build system or dependencies |
| ci | CI configuration |
| chore | Other non-src/test changes |
| revert | Reverts a previous commit |

Breaking changes: add an exclamation mark after type/scope, e.g. feat(core)!: remove v1 API

### Message Rules

- Imperative mood ("add feature" not "added feature")
- Under 72 characters
- No trailing period
- Scope recommended for larger projects (e.g. api, ui, auth)
- Multiple scopes comma-separated: `feat(api,ui): add user profile`
- Focus on what problem this solves and why the change was necessary

### Examples

feat(auth): add OAuth2 login support
fix(api): resolve memory leak in user cache
feat(core)!: remove deprecated v1 API endpoints
docs(readme): update installation instructions
perf(database): optimize user query with indexing
refactor(parser): simplify token validation logic
test(auth): add comprehensive login flow tests

## Repository Context

<!-- prettier-ignore-start -->
<git_status>
!`git status`
</git_status>

<git_log>
!`git log --oneline -10`
</git_log>

<git_diff>
!`git diff --staged`
</git_diff>
<!-- prettier-ignore-end -->
