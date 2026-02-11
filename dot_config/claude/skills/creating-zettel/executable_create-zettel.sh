#!/usr/bin/env bash
set -eu

VAULT="${1:-$HOME/notes}"
NOTES="$VAULT/notes"
TEMPLATES="$VAULT/templates"
TEMPLATE="${2:-}"

# List available templates and exit
if [[ "$TEMPLATE" == "--list-templates" ]]; then
  ls "$TEMPLATES" 2>/dev/null | sed 's/\.md$//'
  exit 0
fi

if [[ ! -d "$NOTES" ]]; then
  echo "error: notes directory not found at $NOTES" >&2
  exit 1
fi

# Generate ID: unix-timestamp + 4-char random uppercase alpha
TIMESTAMP=$(date +%s)
RAND=$(tr -dc 'A-Z' </dev/urandom | head -c4)
ID="${TIMESTAMP}-${RAND}"
FILE="$NOTES/${ID}.md"

if [[ -n "$TEMPLATE" ]]; then
  TMPL_FILE="$TEMPLATES/${TEMPLATE}.md"
  if [[ ! -f "$TMPL_FILE" ]]; then
    echo "error: template not found at $TMPL_FILE" >&2
    exit 1
  fi
  # Prepend frontmatter, then template content
  cat >"$FILE" <<EOF
---
id: ${ID}
aliases: []
tags: []
---

EOF
  cat "$TMPL_FILE" >>"$FILE"
else
  # Bare scaffold
  cat >"$FILE" <<EOF
---
id: ${ID}
aliases: []
tags: []
---

# Title
EOF
fi

echo "created:$FILE"
exit 0
