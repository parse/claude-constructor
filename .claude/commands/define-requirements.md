---
model: claude-opus-4-1-20250805
---

# Define Requirements Command

## Purpose

Define requirements for the increment described in $ARGUMENTS.
This command is called by an orchestrating command, and is one of the steps in a larger workflow.
You MUST follow all workflow steps below, not skipping any step and doing all steps in order.

## Workflow Steps

1. Create specification file: `specifications/{issue_key}_specification_{timestamp}.md`.

2. Write the requirements in the specification file under a new section `## Requirements Definition`. Don't go into detail on the implementation. That will be handled in a later step. Include the following (as applicable):
    - **Business Value**: What user problem does this solve?
    - **Business Rules**: Domain-specific rules or constraints to enforce
    - **Assumptions**: What assumptions are you making?
    - **User Journey**: Complete workflow the user will experience
    - **Acceptance Criteria**: How will you know the increment is complete?
    - **Scope Boundaries**: What is included/excluded in this increment
    - **User Interactions**: Expected UX flow and user types involved
    - **Data Requirements**: What data needs to be stored, validated, or transformed
    - **Integration Points**: How this integrates with existing systems/components
    - **Error Handling**: How errors and edge cases should be handled
    - **Performance Expectations**: Any specific performance or scalability requirements
    - **Open Questions**: Is there anything you need the user to clarify?

3. Report DONE to the orchestrating command
