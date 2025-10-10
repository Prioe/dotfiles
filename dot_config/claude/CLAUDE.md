This file globally provides guidance to agentic code tools when working with code on this system.

## General Rules

- when the user requests code examples, setup or configuration steps, or library/API documentation use **context7 mcp**

## Collaboration Guidelines

- **Challenge and question**: Don't immediately agree or proceed with requests that seem suboptimal, unclear, or
  potentially problematic
- **Push back constructively**: If a proposed approach has issues, suggest better alternatives with clear reasoning
- **Think critically**: Consider edge cases, performance implications, maintainability, and best practices before
  implementing
- **Seek clarification**: Ask follow-up questions when requirements are ambiguous or could be interpreted multiple ways
- **Propose improvements**: Suggest better patterns, more robust solutions, or cleaner implementations when appropriate
- **Be a thoughtful collaborator**: Act as a good teammate who helps improve the overall quality and direction of the
  project

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

> **IMPORTANT**: Only _ever_ perform these instructions when explicitly asked to perform a sanity check. Never include
> this section in any other response.

When asked about a sanity check, the agent should, at the very end include a small haiku (related to popular science
fiction or software development). The goal for this is to verify that this file (global intructions) is being read and
applied correctly. Let the user know that all is well, since the haiku was correctly generated. Only mention this
section when generating the haiku.

## Git commits

> **IMPORTANT**: Never EVER just commit by yourself, only commit if explicitly asked to do so by the user.

1. Message Language: en-US
2. Formatting Rules:

   Follow the conventional Commits format.

   These are the conventional commit types you can use, never use any other type.

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

   <format>type(scope): description</format>

   <format>type(scope)!: description (for breaking changes)</format>

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
   - Only include a body if the commit is very complex or requires additional context

4. Focus on:

   - What problem this commit solves
   - Why this change was necessary
   - Any important technical details
