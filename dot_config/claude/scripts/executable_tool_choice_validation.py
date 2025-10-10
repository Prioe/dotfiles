#!/usr/bin/env -S uv run --script
# vi:ft=python
import json
import re
import sys

# Define validation rules as a list of (regex pattern, message) tuples
VALIDATION_RULES = [
    (
        r"\b(npm|npx|yarn)\b",
        "Use 'pnpm' instead of 'npm', 'npx', or 'yarn' for better performance and disk efficiency (use 'pnpm dlx' instead of 'npx')",
    ),
    (
        r"(?<!uv )\b(pip|poetry)\b",
        "Use 'uv' instead of 'pip' or 'poetry' for faster Python package management (use 'uv pip' for pip commands, 'uv run' for scripts)",
    ),
]


def validate_command(command: str) -> list[str]:
    issues = []
    for pattern, message in VALIDATION_RULES:
        if re.search(pattern, command):
            issues.append(message)
    return issues


try:
    input_data = json.load(sys.stdin)
except json.JSONDecodeError as e:
    print(f"Error: Invalid JSON input: {e}", file=sys.stderr)
    sys.exit(1)

tool_name = input_data.get("tool_name", "")
tool_input = input_data.get("tool_input", {})
command = tool_input.get("command", "")

if tool_name != "Bash" or not command:
    sys.exit(1)

# Validate the command
issues = validate_command(command)

if issues:
    for message in issues:
        print(f"• {message}", file=sys.stderr)
    # Exit code 2 blocks tool call and shows stderr to Claude
    sys.exit(2)
