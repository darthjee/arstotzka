# Folder Structure

## Project Root

| Directory / File | Description |
|-----------------|-------------|
| `lib/` | Gem source code: `lib/arstotzka.rb` (the concern entrypoint) and `lib/arstotzka/` (internal classes). See [architecture.md](architecture.md). |
| `spec/` | RSpec test suite (unit, integration, fixtures and support models). |
| `config/` | Configuration for quality tooling: Yardstick (`yardstick.rb`, `yardstick.yml`), RubyCritic (`rubycritc.rb`) and `check_specs.yml` (lib files exempt from requiring a spec). |
| `scripts/` | CI helper scripts: `check_readme.sh` (README links the current version's YARD docs) and `rubycritic.sh` (RubyCritic comparison against `master`). |
| `docs/agents/` | Agent-facing documentation, issue files and implementation plans. |
| `.circleci/` | CircleCI pipeline: `test` job (RSpec, RuboCop, coverage, Yardstick, README check, RubyCritic, check_specs) and `build-and-release` job (gem push on version tags). |
| `.github/` | PR template, commit message template and Copilot instructions. |
| `arstotzka.gemspec` | Gem specification and dependencies. |
| `Dockerfile`, `docker-compose.yml` | Containerised development environment (`arstotzka` runs RSpec, `test_all` runs RSpec + YARD + Yardstick). |
| `Rakefile` | Rake tasks: RSpec, gem tasks, Yardstick measurement/verification. |
| `.rubocop.yml`, `.rubocop_todo.yml` | RuboCop configuration. |
| `.yardopts` | YARD documentation options. |
| `README.md` | User-facing documentation with usage examples (exercised by `spec/integration/readme`). |

## spec/

| Subdirectory | Description |
|--------------|-------------|
| `lib/` | Unit specs mirroring `lib/` one-to-one (`lib/arstotzka/foo.rb` → `spec/lib/arstotzka/foo_spec.rb`). |
| `integration/readme/` | Specs asserting the examples from `README.md` work. |
| `integration/yard/` | Specs asserting the `@example` blocks from the YARD docs work. |
| `fixtures/` | JSON fixtures loaded by specs. |
| `support/` | Spec helpers, shared examples and `models/` — sample classes including `Arstotzka` used by specs and doc examples. |
