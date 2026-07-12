# Development Commands

## Initial Setup
```bash
bundle install   # Install Ruby gems
```

## Testing
```bash
bundle exec rspec                              # Run all specs (excludes integration specs)
bundle exec rspec spec/hcloud/                 # Run specs in a directory
bundle exec rspec spec/hcloud/client_spec.rb   # Run a single spec file
bundle exec rspec spec/path/to/file_spec.rb:12 # Run specific test at line 12
bundle exec rspec --tag integration            # Run integration specs (hits the real Hetzner Cloud API, needs credentials)
```

See [docs/TESTING.md](TESTING.md) for comprehensive testing documentation.

## Linting
```bash
bundle exec rubocop                    # Run Rubocop linter
bundle exec rubocop -A                 # Auto-correct safe and unsafe offenses
bundle exec rubocop --parallel         # Run in parallel (used in CI)
```

See [docs/STYLE.md](STYLE.md) for code style conventions.

## Documentation
```bash
bundle exec yard        # Generate YARD documentation
bundle exec yard server # Serve YARD documentation locally
```

## Rake
```bash
bundle exec rake        # Default task: runs the RSpec suite
```

## Bundle/Dependency Management
```bash
bundle install   # Install gems
bundle update     # Update gems
```

## Release

Releases are automated via `.github/workflows/ci.yml`: pushing a `v*` tag builds and publishes the gem to RubyGems and creates a GitHub release. Bump the version in `lib/hcloud/version.rb` before tagging.
