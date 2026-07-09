---
name: handoff
description: |
  summarize the current session into a concise, well-structured document for the purpose of persisting important information across agent sessions
---

# Session Handoff

Summarize the current session into a concise, well-structured document for the purpose of persisting important information across agent sessions.

## Process

### Summarize the session

Pick out relevant information that will be useful:

* Key findings
* User instructions
* Uncovered complexity
* Reference files that remain on disk

Omit any information that just pollutes context:

* Chatty tool calls
* Intermediate reasoning
* Dead ends and errors

### Confirm with the user

Ask to confirm the summary, allow the opportunity to refine or correct the summary. Be sure to highlight anything unclear or ambiguous.

### Save the handoff

Create a markdown document in the project root under `./claude/handoffs/[YYYY-MM-DD]-short-description.md`, make sure `./claude/handoffs` is in .gitignore to avoid committing it, add it to .gitignore (create `.gitignore` if it doesn't exist).

Format the document appropriately to the nature of the session, include the following items where relevant:

* Project name
* Date and time
* Project location
* The phase of the session (plan, execution, other)
* What's been done so far
* Key decisions
* Open questions, blockers, issues
* Any important findings or realisations that happened in the course of the session
* What are the next steps
