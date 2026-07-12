# Testing

This document describes the testing setup, conventions, and CI/CD pipeline.

## Testing Setup

**Framework**: RSpec
- Configuration in `spec/spec_helper.rb` and `.rspec`
- Support files under `spec/support/**/*.rb` are loaded automatically
- `spec/support/client.rb` sets a default `HCloud::Client` connection with a dummy access token before the suite runs

**Test Organization**:
- Mirrors the `lib/` directory structure (e.g. `lib/hcloud/resources/server.rb` -> `spec/hcloud/resources/server_spec.rb`)
- `spec/fixtures/` holds fixture files (SSH keys, certificates, metadata) used by specs

**Testing Libraries**:
- **WebMock**: HTTP request stubbing (configured via `require "webmock/rspec"`; real requests are not allowed by default)
- **Timecop**: Time manipulation for time-dependent tests
- **FFaker**: Generating realistic fake data
- **SimpleCov**: Code coverage reporting
- **dotenv**: Loads `.env` for local integration test credentials

## Integration Specs

Specs tagged `:integration` (e.g. `spec/hcloud/resources/server_spec.rb`) hit the real Hetzner Cloud API and require valid credentials. They are excluded from the default `bundle exec rspec` run and only run explicitly via `--tag integration` (CI runs them on a weekly schedule, see `.github/workflows/ci.yml`).

## Testing Conventions

- Specs never need `require "spec_helper"` as it's included in `.rspec`
- Mock external HTTP requests with WebMock; do not hit the real API in unit specs
- Use `let` for memoized variables, `let!` for eager evaluation
- Test the happy path first, then add contexts for alternative and failure paths
- Test edge cases and error conditions (e.g. API error responses, rate limiting)
