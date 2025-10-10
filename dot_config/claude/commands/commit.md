---
allowed-tools:
  [Bash(git status), Bash(git diff), Bash(git log), Bash(git commit), Bash(git add), SlashCommand(/commit-message)]
description: Create a git commit
argument-hint: last-task | staged | all
---

# Commit changes to a git repository

This command allows you to create a git commit with the changes you've made in your repository. You can choose to commit
changes from the last task, only staged changes, or all changes in the repository.

## Command Usage and Arguments

```
/commit <last-task | staged | all>
```

- `last-task`: Commit changes from the last task
- `staged`: Commit only staged changes
- `all`: Commit all changes in the repository

Below are the arguments provided by the user:

<arguments>
$ARGUMENTS
</arguments>

## Workflow

1. Run /commit-message to get a list of commit messages to choose from (Keep going after the SlashCommand finishes!)
2. Review the changes which should be included in the commit
3. Pick the best commit message

### Guidelines

- Do not add a body to the commit message unless specifically requested by the user
- Make sure the correct files are staged for commit, depending on the argument used
