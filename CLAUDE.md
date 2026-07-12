# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

`hcloud` (RubyGems name: `hetznercloud`) is an unofficial Ruby client library for the [Hetzner Cloud API](https://docs.hetzner.cloud/).

## Tech Stack

- **Ruby**: 3.2+ (CI tests 3.2, 3.3, 3.4, 4.0)
- **HTTP client**: `http` gem
- **Object modeling**: ActiveModel, ActiveSupport, Zeitwerk (autoloading)
- **Testing**: RSpec, WebMock (HTTP stubbing), Timecop, FFaker, SimpleCov
- **Linting**: RuboCop (with rubocop-performance, rubocop-rspec)
- **Docs**: YARD
- **CI/CD**: GitHub Actions (test matrix + RubyGems release on tag push)

## Key Conventions

### General

- All Ruby files use `frozen_string_literal: true`
- Double-quoted strings; bracket syntax for symbol/word arrays (`["foo", "bar"]`, `[:foo, :bar]`)
- Resources under `lib/hcloud/resources/` model Hetzner Cloud API entities; keep new resources consistent with existing ones (attributes, associations, actions)
- See [docs/STYLE.md](docs/STYLE.md) for full RuboCop-derived style conventions

### Before committing

Run these checks selectively before each commit, based on the set of modified files:

1. Ensure relevant tests pass: `bundle exec rspec <FILES>` (if any `.rb` files were modified)
2. Ensure no style violations are present: `bundle exec rubocop <FILES>` (if any `.rb` files were modified)

**Note**: CI also enforces these checks (see `.github/workflows/ci.yml`).

## Version control

### Commits

- **Atomic commits**: Each commit should represent a single logical change. Small, focused commits are preferred.
- **Commit messages**: Use clear, descriptive messages in the imperative mood (e.g., "Add user authentication" instead of "Added user authentication").
- **Cohesion**: Keep related changes together (e.g., an implementation change and its corresponding tests).

## Documentation

For detailed information on specific topics, see:

- **[docs/COMMANDS.md](docs/COMMANDS.md)** - Common commands used during development
- **[docs/REFERENCE.md](docs/REFERENCE.md)** - Official Hetzner Cloud API documentation reference
- **[docs/STYLE.md](docs/STYLE.md)** - Ruby code style conventions
- **[docs/TESTING.md](docs/TESTING.md)** - Testing setup, conventions, and CI/CD pipeline
