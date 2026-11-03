# Session naming rules

A session name identifies a session at a glance in a long list: the session picker, the prompt bar, terminal titles and
tab bars.

## Pattern

```
[<project>][<ref>]: <verb> <topic>
```

- Lowercase, plain ASCII, at most 48 characters, no trailing period.
- **project**: the repo name from the session context. Leave it out when the context says `Include project: no`, or when
  the session is not tied to a repo. Without project and ref, the name is just `<verb> <topic>` with no colon.
- **ref**: the issue, MR or PR the session works on, if any. Take it from an explicit mention in the conversation first,
  then from the branch name (`123-foo`, `issue/123`, `feature/PROJ-123-foo`).
  - Same repo as the session: `#123` for issues and GitHub PRs, `!45` for GitLab merge requests.
  - Another repo: `owner/repo#12` on GitHub, `group/project#12` on GitLab. This ref replaces the project.
  - Tracker keys stay verbatim: `PROJ-142`.
- **verb**: one imperative word for the session's main activity, such as add, fix, refactor, debug, review, research,
  configure, plan, triage, bump.
- **topic**: 2 to 4 words naming the central subject. Prefer the user's own nouns over invented shorthand.

## Choosing the task

- Name the main task of the whole session, not the latest message. If the session covered several tasks, name the
  largest one.
- If the session already has a name that still fits the main task, keep it exactly. Only rename when the main task has
  changed.

## Examples

- `dotfiles: add auto-rename plugin`
- `api#231: fix csv export crash`
- `api!45: review pipeline failures`
- `#708: scope measurement sets route` (project left out)
- `rust-lang/rust#1234: debug borrowck regression`
- `research wayland fractional scaling` (no repo)
