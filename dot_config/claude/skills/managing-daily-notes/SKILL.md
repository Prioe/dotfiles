---
name: managing-daily-notes
description: Use when the user wants to work with their daily journal - jotting something down, logging tasks, checking off items, reviewing recent days, or any interaction involving daily notes in their Obsidian vault
allowed-tools: Read(~/notes/**), Write(~/notes/notes/dailies/**), Edit(~/notes/notes/dailies/**), Bash(~/.config/claude/skills/managing-daily-notes/create-daily.sh *)
---

# Daily Note

Manage daily notes in an Obsidian vault. Creates today's note with migrated tasks from the most recent previous note, then fulfills the user's request.

## Flow

```dot
digraph daily_note {
  "User request" [shape=doublecircle];
  "Run create-daily.sh" [shape=box];
  "Today exists?" [shape=diamond];
  "Read today + previous" [shape=box];
  "Remove done tasks" [shape=box];
  "Fulfill request" [shape=doublecircle];

  "User request" -> "Run create-daily.sh";
  "Run create-daily.sh" -> "Today exists?";
  "Today exists?" -> "Read today + previous" [label="yes (script exits early)"];
  "Today exists?" -> "Read today + previous" [label="no (script creates it)"];
  "Read today + previous" -> "Remove done tasks" [label="only on new notes"];
  "Remove done tasks" -> "Fulfill request";
  "Read today + previous" -> "Fulfill request" [label="note already existed"];
}
```

### Step 1: Run the script

```bash
~/.config/claude/skills/managing-daily-notes/create-daily.sh ~/notes
```

Output (two lines, parse both):
```
today:/home/micha/notes/notes/dailies/2026-02-08.md
previous:/home/micha/notes/notes/dailies/2026-02-07.md
```

### Step 2: Read both notes

- **Today's note**: the note to work with
- **Previous note**: read for context (understand what the user was doing recently)

### Step 3: Clean up migrated tasks (only if the script created a new note)

The script copies ALL checkbox lines from the previous note. Remove lines matching `- [x]` (done). Keep everything else:

| Syntax | Meaning | Action |
|--------|---------|--------|
| `- [ ]` | Open | Keep |
| `- [~]` | In progress | Keep |
| `- [!]` | Important | Keep |
| `- [>]` | Deferred | Keep |
| `- [x]` | Done | **Remove** |

### Step 4: Fulfill the user's request

Add content, update tasks, or whatever was asked. Match the language of the user's request — technical notes are typically English, personal notes often German.

## Note Format

```markdown
---
id: "YYYY-MM-DD"
aliases:
  - Month DD, YYYY
tags:
  - daily-notes
---

# Month DD, YYYY
```

Frontmatter fields: `id` (date string), `aliases` (English long-form date), `tags` (always includes `daily-notes`). Heading matches the alias.
