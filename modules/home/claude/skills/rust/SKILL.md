---
name: rust
description: Instructions for working in Rust codebases
---

# Rust

## Common Libraries

Choose from these libraries if you need any of this functionality:

- serde and serde_json for working with JSON
- anyhow for better error handling in binaries
- thiserror for better error handling in libraries
- testresult for handling erros in unit tests
- tokio for async
- bon for builder pattern
- nutype for Newtype pattern
- avoid using async_trait library, it's usually not necessary if you spell out the future types

## Common Rules

### Small functions and composability

Prefer small functions, if a function is more than a screen height, try to split it up. If match arms get big, extract them into functions.

### Prefer immutability

Unless there is a clear benefit, performance or otherwise, always prefer immutable variables.

### Correct by construction

Prefer organizing the code such that any structs have a `new() -> Result<Self>` method that takes any necessary arguments for construction and returns either Ok(self) or an error (thiserror custom error, or an anyhow error depending on where it is). Avoid interior mutability if possible.

### Prefer functional style

If possible, always use iterators, maps and filters instead of for loops. Also for working with Options and Results.

### Avoid unnecessary cloning

Prefer `&str` and `Cow<str>` over `String`, `.to_string()`. Use references over calling clone if possible.

### Don't use unwrap()

Always prefer proper error handling or at least an `.expect()` with a good description.

### Pattern for testable components

If a component needs to be shared or needs multiple implementations, create a trait with the public methods, then for each implementation create a struct with it's config and internal state, but then for `impl Trait for Struct` implement the methods such that they call a free-standing module-internal fn that just takes the minimum parameters and can be tested in isolation.

### Finalize before pushing

After any major code interventions, always run the following:

```shell
cargo fmt
cargo clippy --all-targets
```
