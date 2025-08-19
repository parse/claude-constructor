# Read Configuration Command

## Purpose

Read the correct Claude Constructor configuration file.
Go through the workflow steps one by one. Remember that configuration files with `.local` takes precedence over files that are called the same thing but without the `.local` addition.

## Workflow steps

1. Check if `.claude/settings.claude-constructor.local.json` exists. If it does, read it, skip step 2 and go to step 3.

2. Read `.claude/settings.claude-constructor.json`

3. DONE