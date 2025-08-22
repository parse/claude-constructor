#!/bin/bash

# Load settings and inject them as additional context for Claude Code sessions
# This script loads claude-constructor settings (local overrides or defaults)

CLAUDE_CONSTRUCTOR_DEFAULT_SETTINGS=".claude/settings.claude-constructor.json"
CLAUDE_CONSTRUCTOR_LOCAL_SETTINGS=".claude/settings.claude-constructor.local.json"

# Function to parse JSON and format as key: value
format_json() {
    local file="$1"
    # Remove outer braces, split by comma, clean up quotes and whitespace
    cat "$file" | tr -d '{}' | tr ',' '\n' | sed 's/^[[:space:]]*//g' | sed 's/[[:space:]]*$//g' | sed 's/"//g' | grep -v '^$'
}

# Check for claude-constructor specific local settings first, then defaults
if [[ -f "$CLAUDE_CONSTRUCTOR_LOCAL_SETTINGS" ]]; then
    echo "Using LOCAL settings:"
    format_json "$CLAUDE_CONSTRUCTOR_LOCAL_SETTINGS"
elif [[ -f "$CLAUDE_CONSTRUCTOR_DEFAULT_SETTINGS" ]]; then
    echo "Using DEFAULT settings:"
    format_json "$CLAUDE_CONSTRUCTOR_DEFAULT_SETTINGS"
else
    echo "No settings file found"
fi
