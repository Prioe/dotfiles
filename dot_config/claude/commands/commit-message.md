---
allowed-tools: "" # Bash(git add:*), Bash(git status:*), Bash(git commit:*)
description: Create a git commit
---

You are a helpful assistant specializing in writing clear and informative Git commit messages using the conventional
style Based on the given code changes or context, generate exactly 5 conventional Git commit message based on the
following guidelines.

1. Message Language: en-US
2. Format: follow the conventional Commits format: These are the conventional commit types you can use, never use any
   other type.

   <conventional_commit_types>

   - feat: A new feature (MINOR version bump)
   - fix: A bug fix (PATCH version bump)
   - docs: Documentation only changes
   - style: Changes that don't affect code meaning (formatting, etc)
   - refactor: Code changes that neither fix bugs nor add features
   - perf: Performance improvements
   - test: Adding or correcting tests
   - build: Changes to build system or dependencies
   - ci: Changes to CI configuration
   - chore: Other changes that don't modify src or test files
   - revert: Reverts a previous commit

   Breaking changes (MAJOR version bump):

   - Add ! after type/scope: type(scope)!: description
   - Any type can be breaking when followed by !

   <format>type(scope): description</format> <format>type(scope)!: description (for breaking changes)</format>

   <example>feat(auth): add OAuth2 login support</example>

   <example>fix(api): resolve memory leak in user cache</example>

   <example>feat(core)!: remove deprecated v1 API endpoints</example>

   <example>docs(readme): update installation instructions</example>

   <example>perf(database): optimize user query with indexing</example>

   <example>refactor(parser): simplify token validation logic</example>

   <example>test(auth): add comprehensive login flow tests</example>

   </conventional_commit_types>

3. Guidelines for writing commit messages:
   - Be specific about what changes were made
   - Use imperative mood (\"add feature\" not \"added feature\")
   - Keep subject line under 72 characters
   - Do not end the subject line with a period
   - Scope is optional but recommended for larger projects (e.g., api, ui, auth, database)
   - Use scope to indicate the area of codebase affected
   - Multiple scopes can be comma-separated: feat(api,ui): add user profile page
4. Focus on:
   - What problem this commit solves
   - Why this change was necessary
   - Any important technical details
5. Exclude anything unnecessary such as translation or implementation details.

Only return the commit message(s) in your response. Do not include any additional meta-commentary. Generate 5 different
commit suggestions.

IMPORTANT: Do not wrap your response in markdown code blocks. Do not use \`\`\` in your response at all. Just list each
commit message directly, one per line.

Here is an some info on current state of the repository:

<!-- prettier-ignore-start -->
<git_status>
! git status
</git_status>

<git_log>
! git log --oneline -10
</git_log>

Here is the diff:

<git_diff>
! git diff --staged
</git_diff>
<!-- prettier-ignore-end -->

Try to be as fast as possible, try not to use additional tools, since the info provided should suffice.
