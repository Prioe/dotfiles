#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "usage: check-changelog.sh [--since X.Y.Z] [--all]" >&2
  exit 1
}

SINCE=""
ALL=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --since) SINCE="${2:-}"; shift 2 ;;
    --all) ALL=1; shift ;;
    *) usage ;;
  esac
done

if [[ -z "$SINCE" ]]; then
  SINCE="$(claude --version 2>/dev/null | awk '{print $1}')"
fi
if [[ ! "$SINCE" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "error: could not determine installed version (got '$SINCE'); pass --since X.Y.Z" >&2
  exit 1
fi

CHANGELOG="$(gh api -H "Accept: application/vnd.github.raw" repos/anthropics/claude-code/contents/CHANGELOG.md 2>/dev/null \
  || curl -fsSL https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md)"

LATEST="$(grep -m1 '^## ' <<<"$CHANGELOG" | awk '{print $2}')"

newer_than_since() {
  [[ "$(printf '%s\n%s\n' "$1" "$SINCE" | sort -V | tail -n1)" == "$1" && "$1" != "$SINCE" ]]
}

BEHIND=0
SECTIONS=""
PRINTING=0
while IFS= read -r line; do
  if [[ "$line" =~ ^##\ ([0-9]+\.[0-9]+\.[0-9]+) ]]; then
    if newer_than_since "${BASH_REMATCH[1]}"; then
      PRINTING=1
      BEHIND=$((BEHIND + 1))
    elif [[ $ALL -eq 0 ]]; then
      break
    else
      PRINTING=1
    fi
  fi
  [[ $PRINTING -eq 1 ]] && SECTIONS+="$line"$'\n'
done <<<"$CHANGELOG"

echo "installed: $SINCE"
echo "latest: $LATEST"
if [[ $BEHIND -eq 0 ]]; then
  echo "status: up to date"
else
  echo "status: $BEHIND release(s) behind"
fi
echo
printf '%s' "$SECTIONS"
