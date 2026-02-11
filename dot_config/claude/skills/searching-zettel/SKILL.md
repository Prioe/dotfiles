---
name: searching-zettel
description: Use when the user wants to find, look up, or recall notes from their Obsidian zettelkasten - searching by topic, tag, title, or content, answering questions like "what did I write about X" or "do I have a recipe for Y"
allowed-tools: Read(~/notes/**), Grep(~/notes/**), Glob(~/notes/**)
---

# Searching Zettel

Search and retrieve notes from an Obsidian zettelkasten vault at ~/notes.

## Vault Structure

- `~/notes/notes/*.md` — zettelkasten notes (UNIX-timestamp + 4-char ID filenames)
- `~/notes/notes/dailies/*.md` — daily journal entries (YYYY-MM-DD.md)

Notes have YAML frontmatter with `id`, `aliases` (human-readable title), and `tags` fields. Some notes use inline tags as `#hashtags` inside blockquotes.

## Search Strategies

Use whichever fits the request. Combine multiple Grep calls in parallel for better coverage.

| Goal | How |
|------|-----|
| By content | `Grep(pattern, path="~/notes/notes")` |
| By frontmatter tag | `Grep(pattern="^  - <tag>", path="~/notes/notes")` |
| By title/alias | `Grep(pattern="<term>")` searching aliases lines |
| By inline tag | `Grep(pattern="#<tag>", path="~/notes/notes")` |

After finding matches, Read the relevant notes and present findings. Include daily notes only if the request is about journal entries or recent activity.

## When NOT to Use

- Creating a new note → use `creating-zettel`
- Working with today's daily journal → use `managing-daily-notes`
