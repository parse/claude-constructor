#!/bin/bash

# Load settings and inject them as additional context for Claude Code sessions
# This script loads claude-constructor settings (local overrides or defaults)

CLAUDE_CONSTRUCTOR_DEFAULT_SETTINGS=".claude/settings.claude-constructor.json"
CLAUDE_CONSTRUCTOR_LOCAL_SETTINGS=".claude/settings.claude-constructor.local.json"

# Initialize context
ADDITIONAL_CONTEXT=""

# Check for claude-constructor specific local settings first, then defaults
if [[ -f "$CLAUDE_CONSTRUCTOR_LOCAL_SETTINGS" ]]; then
    ADDITIONAL_CONTEXT="Local Claude Constructor settings loaded from $CLAUDE_CONSTRUCTOR_LOCAL_SETTINGS:\n$(cat "$CLAUDE_CONSTRUCTOR_LOCAL_SETTINGS")"
elif [[ -f "$CLAUDE_CONSTRUCTOR_DEFAULT_SETTINGS" ]]; then
    ADDITIONAL_CONTEXT="Default Claude Constructor settings loaded from $CLAUDE_CONSTRUCTOR_DEFAULT_SETTINGS:\n$(cat "$CLAUDE_CONSTRUCTOR_DEFAULT_SETTINGS")"
fi

# Always output context if we have settings
if [[ -n "$ADDITIONAL_CONTEXT" ]]; then
    cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "$ADDITIONAL_CONTEXT"
  }
}
EOF
fi