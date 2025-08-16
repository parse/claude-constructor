# Specification Sign-Off Command

## Purpose

Get sign-off on the specification for the increment to be implemented for the issue described in $ARGUMENTS.
This command is called by an orchestrating command, and is one of the steps in a larger workflow.
You MUST follow all workflow steps below, not skipping any step and doing all steps in order.

## Workflow Steps

1. Ask the user to read and provide feedback on the Implementation Plan section in the specification file linked in $ARGUMENTS

2. Iterate on the specification until the user gives their sign-off

3. Add specification comment - run the .claude/commands/issue/create-comment.md command, passing the issue key and specification details as arguments to it

    Get the issue key from the state management file in $ARGUMENTS.

    Format the arguments as:
    ```
    Issue Key: [issue key from state management file]
    Comment Text: [specification details and assumptions]
    ```

4. Report DONE to the orchestrating command
