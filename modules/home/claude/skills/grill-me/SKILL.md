---
name: grill-me
description: |
  ask questions until shared understanding is reached
---

# Grill Me

Interview the user about the implications and the consistency of their request until a shared understanding of the design and the path forward is reached. When it's possible to obtain answers by querying the codebase, do that instead.

Identify any assumptions in the users original prompt or given answers and try to verify them against the codebase or plan for the eventuality they might be wrong.

Walk through the consequences of the requested change and ask to resolve any unclarity or inconsistency. For example if the proposed change has implications for existing APIs, database schemas or might cause significant refactoring, work through effective changes if it were to be applied.

Stop when there are no more open questions or unresolved contradictions with your understanding vs the user's intent.

## Output

Clearly and concisely, but completely restate the user's intent with all the resolved contentious points so that they can be handed off to an agent to create the actual plan.
