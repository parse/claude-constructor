# Create Pull Request Command

## Purpose

Create pull request for increment implemented to satisfy the issue described in $ARGUMENTS.
Add, commit, push code for the finished increment. Create Pull request in GitHub using the `gh` CLI.
This command is called by an orchestrating command, and is one of the steps in a larger workflow.
You MUST follow all workflow steps below, not skipping any step and doing all steps in order.

## Workflow Steps

1. List unstaged changes using `git status`

2. Read the specification linked in $ARGUMENTS to and compare with unstaged changes to understand how the increment has been implemented and which unstaged changes are relevant to the increment. Ignore the specifications and state_management folders.

3. Create a git commit using the guidelines in `docs/git-commit.md`

4. Push the commit using `git push`

5. Read the default branch name from the "default-branch" field in .claude/settings.claude-constructor.json

6. Create a pull request using `gh pr create --title "feat: [issue key] [brief description from commit]" --base [default branch name] --head $(git branch --show-current)`

7. Update issue status to "Code Review" - run the .claude/commands/issue/update-issue.md command, passing the issue key and new status as arguments to it

Get the issue key from the state management file in $ARGUMENTS.

Format the arguments as:
```
Issue Key: [issue key from state management file]
New Status: Code Review
```

8. Update Linear issue status to "Code Review" using `linear:update_issue`

9.  Report DONE to the orchestrating command
