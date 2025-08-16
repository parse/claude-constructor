---
model: claude-opus-4-1-20250805
---

# Write Specification Command

## Purpose

Write the specification for the increment to be implemented for the issue described in $ARGUMENTS.
This command is called by an orchestrating command, and is one of the steps in a larger workflow.
You MUST follow all workflow steps below, not skipping any step and doing all steps in order.

## Core Principle

**IMPLEMENT THE ISSUE AS WRITTEN.** Each workflow execution should implement the complete issue requirements to deliver the intended business value.

## Workflow Steps

1. Read $ARGUMENTS to understand the issue

2. Analyze the requirements in the specification file, under Requirements Definition

3. Analyze the codebase to understand what files you need to edit

4. Ultrathink about parallelization strategy:
    - Identify independent components (e.g., backend endpoints, frontend components, database migrations)
    - Determine dependencies between components
    - Group related changes that must be done sequentially

5. Write detailed specification with parallelization plan, in a new section called `## Implementation Plan`:
    - Include dependency graph showing which pieces can run in parallel
    - Assign agent IDs (e.g., agent-1, agent-2) to parallelizable work
    - Mark sequential dependencies clearly
    - Do not include end-to-end tests, since they will be covered in a later step of the workflow

    Example structure:
    
    Parallelization Plan
    - agent-1: Backend API endpoint (no dependencies)
    - agent-2: Database migration (no dependencies)
    - agent-3: Frontend component (depends on agent-1)
    - agent-4: Integration tests (depends on agent-1, agent-2)

6. Report DONE to the orchestrating command
