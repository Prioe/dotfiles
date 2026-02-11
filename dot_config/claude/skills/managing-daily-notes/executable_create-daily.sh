#!/usr/bin/env bash
set -euo pipefail

VAULT="${1:-$HOME/notes}"
DAILIES="$VAULT/notes/dailies"

if [[ ! -d "$DAILIES" ]]; then
  echo "error: dailies directory not found at $DAILIES" >&2
  exit 1
fi

TODAY=$(date +%Y-%m-%d)
TODAY_FILE="$DAILIES/$TODAY.md"

# Find most recent daily note (excluding today if it exists)
PREV=$(ls -1 "$DAILIES" | grep -v "^${TODAY}.md$" | sort -r | head -1)

if [[ -f "$TODAY_FILE" ]]; then
  echo "today:$TODAY_FILE"
  [[ -n "$PREV" ]] && echo "previous:$DAILIES/$PREV"
  exit 0
fi

# Generate English date alias: "February 8, 2026"
ALIAS=$(date -d "$TODAY" +"%B %-d, %Y" 2>/dev/null || date -j -f "%Y-%m-%d" "$TODAY" +"%B %-d, %Y" 2>/dev/null)

# Create today's note
cat >"$TODAY_FILE" <<EOF
---
id: "$TODAY"
aliases:
  - $ALIAS
tags:
  - daily-notes
---

# $ALIAS
EOF

# Copy all checkbox lines from previous note
if [[ -n "$PREV" ]]; then
  CHECKBOXES=$(grep -E '^\s*- \[.\]' "$DAILIES/$PREV" || true)
  if [[ -n "$CHECKBOXES" ]]; then
    printf '\n%s\n' "$CHECKBOXES" >>"$TODAY_FILE"
  fi
fi

echo "created:today:$TODAY_FILE"
[[ -n "${PREV:-}" ]] && echo "previous:$DAILIES/$PREV"
exit 0
