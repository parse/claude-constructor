# Claude Constructor

A systematic workflow engine for implementing functionality with Claude Code, designed with quality-driven development practices and planning at the center.

## Overview

This system orchestrates feature development through a structured 12-step workflow that covers complete implementation, comprehensive testing, and automated code review. Each command works together as part of a larger orchestrated process.
The goal has been to enable Claude Code to work for extended periods of time without deviating from the plan.

## Core Workflow

The main orchestrator (`feature.md`) follows this sequence:

### Planning
1. **Read configuration files** - Load development guidelines, quality gates, and other documentation
2. **Create state management file** - Used to track workflow progress
3. **Read Jira issue** - Fetch issue details via Jira MCP
4. **Define implementation plan** - Complete business value delivery strategy
5. **Write specification** - Technical spec with parallelization plan
6. **Get specification sign-off** - Iterate on the specification until it's ready *(Human Required)*

### Implementation
7. **Check out new branch** - Create feature branch
8. **Implement increment** - Execute with parallel sub-agents if possible

### Review
9. **Perform code review** - Self-review, addressing findings automatically
10. **Create pull request** - Creating a pull request on GitHub, describing the work
11. **Review pull request** - Monitor and respond to feedback *(Human Required)*

## Usage

There are two ways of using this workflow.

1. Put the command files in your `.claude/commands` folder (either in your project or your home directory), and docs/ in the root of your project.
Then run the following:

```bash
> claude
> /feature ABC-123
```

2. Run the workflow from this directory, to make changes in a different code base.
This enables you to reuse this workflow with any repository without copying/moving files.

```bash
> claude
> /add-dir $path_to_target_repository
> /feature ABC-123
```

Documentation for [`--add-dir`](https://docs.anthropic.com/en/docs/claude-code/cli-reference).

Notes:
- If you want to skip the issue tracking system you could update the workflow to start with a prompt instead

## Configuration

This repository is a work in progress, and there are things you might want to change to fit your setup better.
Such as:

- Using a different issue tracking system
- Using different status transitions
- Adding reference points for your specific way of doing things
- Tweaking your technical guardrails (described in `CLAUDE.md`). I recommend using pre-commit hooks and/or Claude Code hooks and/or CI to make sure the technical guardrails are enforced. TDD is also a great instrument in my opinion.
- Adapting the git branch and commit guidelines to suit your preferences

## Key Features

### Extensive Planning
- Focus on creating a solid plan before starting any work
- Transparent description of Claude Code's understanding of the work to be done, and assumptions made

### Parallel Execution
- Specifications identify independent components (backend APIs, frontend components, database migrations)
- Agent IDs assigned for parallel work with dependency management

### State Management
- Persistent tracking across all workflow steps in `state_management/{issue_key}.md`
- TODO list maintenance and resumable workflows

### Issue Tracking Integration
- Issue status updates at each workflow stage
- Progress comments with implementation details

## Human-in-the-Loop Points

The workflow includes critical human approval gates:

### 1. Specification Sign-off (Step 6)
- **Human Required**: Must approve technical specification before implementation begins
- **Process**: Claude Code presents assumptions and detailed specification for review
- **Workflow**: Cannot proceed to implementation until human approval is given

### 2. Pull Request Review (Step 12)
- **Human Required**: Reviewing and approving pull request on GitHub
- **Process**: Human adds comments/feedback directly in GitHub PR interface as part of a Review
- **Workflow**: Claude monitors for new comments but must be asked to check for updates, and the Review needs to be submitted

### 3. Merging Pull Request (After Step 12)
- **Human Required**: Must merge the pull request manually

These gates ensure human oversight of decisions and final code quality before delivery.

I also recommend checking in on the work as it is happening, to gauge if anything was missed in the specification or otherwise not going according to plan.

## Prerequisites

### Technical Requirements
- Jira MCP integration configured
- GitHub CLI (`gh`) authenticated
- Git repository with `main` branch
- Quality gate tools available

### Required Configuration Files
- `/CLAUDE.md` - General principles, quality gates, and development workflow
- `docs/git-commit.md` - Git commit guidelines

### Optional Configuration Files
- `docs/requirements.md` - Domain principles and business rules (can be referenced during implementation planning and code review)
- ...and any additional context

### Issue Requirements
**The workflow assumes well-groomed issues.** Users must ensure Jira issues contain:
- Clear problem definition and business context
- Detailed feature requirements and acceptance criteria
- Proposed solution approach or architecture direction
- Sufficient domain context for implementation decisions
- Any relevant technical constraints or considerations

The quality of the implementation depends directly on the quality of the issue description and context provided.

## File Structure

In this repository:

```
.claude/commands/
├── feature.md                      # Main orchestrator
├── create-state-management-file.md
├── read-issue.md
├── define-implementation-plan.md
├── write-specification.md
├── specification-signoff.md
├── git-checkout.md
├── implement-increment.md
├── implement-sub-increment.md
├── code-review.md
├── create-pull-request.md
└── review-pull-request.md

docs/
└── git-commit.md
```

In the target repository:

```
state_management/                   # Generated during workflow
└── {issue_key}.md

specifications/                     # Generated during workflow
└── {issue_key}_specification_{timestamp}.md
```

## Tips

- Set CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1 in your environment variables to force Claude Code to always return to the original working directory after each Bash command. This saves on both tokens and Claude being confused about where it is.
