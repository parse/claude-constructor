# Read Issue Command

## Purpose

Read Jira issue for the issue key listed in $ARGUMENTS and note all information in $ARGUMENTS.
This command is called by an orchestrating command, and is one of the steps in a larger workflow.
You MUST follow all workflow steps below, not skipping any step and doing all steps in order.

## Workflow Steps

1. Read $ARGUMENTS and extract the Jira issue key

2. Read Jira issue

**Use Jira MCP to fetch issue details using Jira issue key**:
- Get issue key, ID, title, and description

**Jira lookup example**: `jira:get_issue` with query containing Jira issue key listed in $ARGUMENTS after `Jira Issue Key:`

3. Note findings in $ARGUMENTS

Create a new section called `## Jira Issue Information`, with information on this format:
- **Key**: Issue key
- **ID**: Issue ID
- **Title**: Issue title
- **Description**: Issue description

4. Report DONE to the orchestrating command
