#!/bin/bash

# Read JSON from stdin and extract file_path using simpler pattern matching
input=$(cat)

# Extract file_path using a simpler approach
file_path=$(echo "$input" | grep -o '"file_path" *: *"[^"]*"' | cut -d'"' -f4)

# If no file path found, try alternative extraction
if [ -z "$file_path" ]; then
    file_path=$(echo "$input" | sed -n 's/.*"file_path" *: *"\([^"]*\)".*/\1/p')
fi

# If still no file path, allow operation
if [ -z "$file_path" ]; then
    exit 0
fi

# Get current working directory
current_dir=$(pwd)

# Convert relative path to absolute path
if [[ "$file_path" = /* ]]; then
    # Already absolute
    abs_file_path="$file_path"
else
    # Relative path - prepend current directory
    abs_file_path="$current_dir/$file_path"
fi

# Simple path normalization - remove redundant slashes and current directory references
abs_file_path=$(echo "$abs_file_path" | sed 's|//\+|/|g' | sed 's|/\./|/|g')

# Handle parent directory references more carefully
while [[ "$abs_file_path" =~ /[^/]+/\.\./  ]]; do
    abs_file_path=$(echo "$abs_file_path" | sed 's|/[^/]\+/\.\./|/|')
done

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
