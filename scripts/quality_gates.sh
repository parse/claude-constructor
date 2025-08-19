#!/bin/bash

# Check if quality-gates-check-path is configured in local claude-constructor settings only
get_quality_gates_path() {
    local local_settings_file=".claude/settings.claude-constructor.local.json"

    # Only check local settings file (opt-in only)
    if [[ -f "$local_settings_file" ]]; then
        grep -o '"quality-gates-check-path"[[:space:]]*:[[:space:]]*"[^"]*"' "$local_settings_file" | \
        sed 's/.*"quality-gates-check-path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/'
    fi
}

# Get the configured path
check_path=$(get_quality_gates_path)

# Only run if quality-gates-check-path is configured
if [[ -n "$check_path" ]]; then
    echo "🚪 Quality gates enabled, searching for '$check_path' scripts..."
    if [[ -f "$check_path" ]]; then
        echo "Running quality gates: $check_path"
        cd "$(dirname "$check_path")" && ./$(basename "$check_path")
    else
        echo "⚠️  Quality gates script not found: $check_path"
    fi
else
    echo "⏭️  Quality gates not configured, skipping"
fi