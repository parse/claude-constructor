# Requirements Sign-Off Command

## Purpose

Get sign-off on the requirements for the increment to be implemented for the issue described in $ARGUMENTS.
This command is called by an orchestrating command, and is one of the steps in a larger workflow.
You MUST follow all workflow steps below, not skipping any step and doing all steps in order.

## Workflow Steps

1. Ask the user to read and provide feedback on the Requirements Definition section in the specification file linked in $ARGUMENTS

2. Update requirements based on feedback. Repeat until user provides explicit sign-off

3. Report DONE to the orchestrating command
