---
name: creating-zettel
description: Use when the user wants to create a new note in their Obsidian zettelkasten vault - writing about a topic, capturing an idea, adding a recipe, or any new permanent note that is not a daily journal entry
allowed-tools: Read(~/notes/**), Write(~/notes/notes/**), Edit(~/notes/notes/**), Bash(~/.config/claude/skills/creating-zettel/create-zettel.sh *)
---

# Creating Zettel

Create new zettelkasten notes in the Obsidian vault at ~/notes.

## Flow

1. Pick a template if one fits the request, otherwise omit.

   Available templates: !`~/.config/claude/skills/creating-zettel/create-zettel.sh ~/notes --list-templates`

2. Run: `~/.config/claude/skills/creating-zettel/create-zettel.sh ~/notes [template-name]`
   Parse the output line `created:<path>`.

3. Read the created file.

4. Fill in:
   - `aliases`: human-readable title
   - `tags`: relevant tags as a list
   - `# Heading`: matching the alias
   - Content based on the request. If created from a template, fill in the template sections.

5. If the request is ambiguous, clarify before writing.

Match the language of the request — technical notes typically English, personal notes often German.

## URL Bookmarks

When the user provides a URL to create a note for, keep it **brief** — just enough to find the URL again later:
- Title/alias describing what the link is about
- The URL itself as a markdown link
- 1-3 sentence summary at most
- Relevant tags for discoverability

Do NOT write a full summary or deep analysis of the URL content.

## Quick Reference

| Field | Format |
|-------|--------|
| Filename | `notes/<unix-timestamp>-<4-CHAR>.md` |
| `id` | Same as filename stem |
| `aliases` | Human-readable title |
| `tags` | List of relevant tags |

## When NOT to Use

- Daily journal entries → use `managing-daily-notes` skill instead
- Editing an existing note → just edit it directly
