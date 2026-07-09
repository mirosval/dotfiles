---
name: refactor
description: |
  invoked by the user to identify refactoring opportunities in the codebase
---

# Refactor

Instructions for looking around a codebase and identifying common issues that will improve code quality but not change the business logic.

Each of the following sections is a self-contained pattern that can be evaluated using a parallel agent. When the agents return, choose the most one most impactful change, but don't mix multiple axes of refactoring in one changeset. Create a handoff document with recommendations on what to change that can be picked up by an agent to plan the work.

## Layering issues

Code should be typically organized into layers, there should be input and output layers and business logic layers.

The IO layers are typically APIs, GRPC, HTTP, filesystem or databases. These layers should have their own models that correspond to the representation of the data in the target medium, for instance a database model should be as close as possible to 1:1 representation of a row in a single table, including compatible types etc.

There should be conversion code from the IO layer to the business layer that should avoid the application of any business logic.

The business layers should never contain any references to any IO, they should largely be composed of business-level models and pure functions that act upon them. This makes it easy to test business logic in isolation.

### How to spot

Identify which layer is which, typically business layers will be sandwiched between IO layers.
If no discernible layers can be identified, propose to create them.

Common patterns for incorrect layering:
* IO or IO models used in business logic
* Business logic applied in an IO layer
* Leaky abstractions

## Crowded modules

In languages that allow arbitrary module structure, such as Rust, Python or TypeScript, look for modules that contain multiple layers, do more than one thing at once or don't correspond to their name.

Split these modules, aim for good correspondence between names and content, small volume of code, high degree of colocation.

## Premature abstraction

Sometimes there is an abstraction such as a trait or an interface that has outgrown it's natural size and should be split or abandoned. This can be spotted if there is code that relies on guessing the implementor or uses internal state to conditionally perform something that doesn't quite match the trait.

## Missing abstraction

When there is code repetition, or similar patterns occurring in multiple (3 or more) places, it might be good to abstract some of it away or create common functions.
