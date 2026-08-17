---
name: simplifying-prose
description: "Plain English rules for functional prose: rewriting text or writing commits, issues, notes, docs."
---

# Plain English for Functional Prose

Functional prose is text that exists to carry facts to a reader, not to impress: code comments and docstrings, docs and
READMEs, commit messages, issue and MR/PR descriptions, changelogs, ADRs, zettel and daily notes, review comments, chat
and mail drafts, error and log messages. These rules apply whenever you rewrite such text or write it fresh. Adapted
from the rewrite prompts of the claudish-to-english plugin.

## Two modes

**Rewriting** existing prose is a translation, not an edit: every fact survives, only the wording gets simpler.

- Operate only on the prose the user points at: a doc, a README, comments in a file, a commit message, a draft reply. Do
  not expand scope to neighboring files or sections the user did not name.
- In code files, rewrite only comments and docstrings. Never touch code, identifiers, string literals, or anything the
  program executes.
- In Markdown, rewrite prose only. Reproduce fenced code blocks, inline code spans, and YAML frontmatter exactly.
- Keep all structure: headings, lists, tables, and links in Markdown; comment markers, indentation, and doc-comment
  conventions in code. Rewrite at the sentence level, do not reorganize.
- Output only the rewrite. No preamble ("Here is the simplified version"), no labels, no notes about what changed. When
  editing files, make the edits and report briefly; do not annotate the text itself.
- Rewrite, never respond. A question in the text stays a question, just plainer. Use surrounding context only to
  understand the text, not to answer it.

**Writing** new prose (a commit message, an issue description, a note, a changelog entry) applies the same language
rules from the first draft; never write claudish and simplify afterwards. Format conventions from other skills and
CLAUDE.md (commit style, issue templates, note structure) stay in charge; this skill governs the sentences inside them.

## Language rules (both modes)

1. Use short sentences and everyday words. One idea per sentence. Prefer the common word when it is just as exact.
2. Facts are load-bearing. Rewriting: keep every fact, name, number, link, and file path; never drop or add information.
   Writing: state exactly the facts the reader needs, no padding. If a plainer phrasing would lose a distinction, keep
   the distinction.
3. Active voice with a concrete subject: "the hook buffers each chunk", not "chunks are buffered by the hook".
4. Cut hedges and filler: "it's worth noting that", "essentially", "in order to", "leverages", "robust", "seamlessly".
5. Unpack jargon the reader may not know; keep a technical term when it is the precise name of the thing, and let the
   sentence around it explain what it does.
6. Shorter is a side effect, not the goal. Do not summarize; a text full of facts stays long, just clearer.

Before:

> This implementation leverages an exponential backoff strategy to gracefully handle transient failures, ensuring that
> retry attempts are spaced out to mitigate the risk of overwhelming the upstream service.

After:

> If a call fails for a temporary reason, it is retried. Each retry waits longer than the last (exponential backoff), so
> the retries do not overwhelm the upstream service.

## When to leave text alone

Already-plain text stays as it is, whatever its length. Do not churn wording for its own sake; a second pass over
rewritten text should change nothing.

## Comments in code

This skill changes the wording of a comment, not whether it should exist. When a comment fails the writing-comments test
(delete it: could someone now silently break something?), deleting beats simplifying; apply that skill's rules first,
then simplify what remains.
