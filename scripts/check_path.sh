#!/bin/bash

# Read JSON from stdin and extract file_path
file_path=$(jq -r '.tool_input.file_path // ""')

# If no file path, allow operation
if [ -z "$file_path" ]; then
    exit 0
fi

# Get absolute path of the file
abs_file_path=$(realpath "$file_path" 2>/dev/null || echo "$file_path")

# Get current working directory
current_dir=$(pwd)

# Check if file is under current directory
case "$abs_file_path" in
    "$current_dir"/*)
        echo "Edits are not allowed in this repository. Use external directories added with /add-dir." >&2
        exit 2
        ;;
    *)
        exit 0
        ;;
esac
