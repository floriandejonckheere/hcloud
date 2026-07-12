# Code Style

This document describes the code style conventions used in the gem, derived from `.rubocop.yml`.

## Ruby Style (RuboCop)

- Double quotes for strings (`Style/StringLiterals`)
- Trailing commas for multiline arrays/hashes/arguments, only when they span multiple lines (`consistent_comma`)
- Bracket syntax for symbol/word arrays: `["foo", "bar"]`, `[:foo, :bar]`
- Indented multiline method calls (`Layout/MultilineMethodCallIndentation`)
- Line length checking is disabled (`Layout/LineLength`)
- Method length checking is disabled (`Metrics/MethodLength`)
- Max ABC size: 25 (`Metrics/AbcSize`)
- Parameter list length checking is disabled (`Metrics/ParameterLists`)
- Target Ruby version: 3.2
- Plugins enabled: rubocop-performance, rubocop-rspec
- Class-level YARD documentation comments are not required (`Style/Documentation`)
- One class per file, except under `spec/support/`

### Alignments

Do NOT align assignments or blocks spanning multiple lines.

NOT good:

```ruby
scope_one   = 1
scope_two   = 22
scope_three = 333
```

Good:

```ruby
scope_one = 1
scope_two = 22
scope_three = 333
```

## General Code Conventions

- All Ruby files use `frozen_string_literal: true`
- Use `binding.break` for debugging (debug gem)
