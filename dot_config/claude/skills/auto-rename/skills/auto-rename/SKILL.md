---
name: auto-rename
description: Name or rename the current session after its main task, and hand a manually named session back to automatic naming. Use when the user invokes /auto-rename or asks to name or rename the current session.
allowed-tools:
  - Bash(~/.config/claude/skills/auto-rename/scripts/auto-rename apply:*)
model: haiku
---

# Auto rename

The plugin's hook renames the session in the background every few prompts. This skill does the same on demand. It also
hands a session you renamed by hand back to the hook.

## Rules and session context

!`~/.config/claude/skills/auto-rename/scripts/auto-rename context`

## Flow

1. Find the main task of the whole session, not just the latest message.
2. Compose the name with the rules above. Do not keep the current name only because it exists; the user asked for a
   fresh look.
3. Apply it:

   ```bash
   ~/.config/claude/skills/auto-rename/scripts/auto-rename apply "<name>"
   ```

4. Confirm the new name to the user in one short sentence.

If the script fails, give the user a copyable command in a fenced code block instead:

```
/rename <name>
```
