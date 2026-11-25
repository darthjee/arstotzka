# Project Instructions

Arstotzka is a Ruby gem (a concern to be included in classes) for quick, declarative
fetching of values from nested hashes / JSON. It avoids code that crawls through a hash
constantly checking for `nil` values or missing keys and, like `OpenStruct`, lets the data
be read as an object — but without `method_missing`, since every attribute is a declared
method (returning `nil` when data is absent). It also supports key case changing
(e.g. camelCase ↔ snake_case), type casting, wrapping values in classes and post-processing,
having been built as a bridge between Rails applications and Java APIs.

## Stack

- Ruby (>= 2.5) gem — runtime dependencies: `activesupport`, `sinclair`
- Tests: RSpec (`spec/`), with SimpleCov coverage
- Linting / quality: RuboCop (+ `rubocop-rspec`), Reek, RubyCritic
- Documentation: YARD, with Yardstick measuring doc coverage (`config/yardstick.yml`)
- Tooling: Docker / docker-compose for local runs, CircleCI for CI and gem release

## Conventions

- Every Ruby file starts with `# frozen_string_literal: true`.
- Maximum line length is 100 characters; code must pass `rubocop` (see `.rubocop.yml`).
- Public API must be documented with YARD; Yardstick coverage (`rake verify_measurements`)
  must not drop.
- Every file in `lib/` has a matching spec under `spec/lib/` (enforced by `check_specs`,
  configured in `config/check_specs.yml`); integration specs live in `spec/integration/`
  and support models in `spec/support/`.
- The README documents the current version (checked by `scripts/check_readme.sh`) —
  keep it in sync when bumping `lib/arstotzka/version.rb`.
- Run the suite with `docker-compose run arstotzka` (RSpec) or
  `docker-compose run test_all` (RSpec + YARD + Yardstick), or directly with
  `bundle exec rspec` and `rubocop`.

## Documentation

All project documentation lives under [`docs/agents/`](docs/agents/):

| File | Contents |
|------|----------|
| [Folder Structure](docs/agents/folder-structure.md) | Top-level directory layout and the role of each folder. |
| [Architecture](docs/agents/architecture.md) | Source layout, modules, code style, and implementation guidelines. |
| [Flow](docs/agents/flow.md) | Main runtime flow of the application. |
| [Contributing](docs/agents/contributing.md) | Commit guidelines, PR standards, code organization, and refactoring rules. |
| [Plans](docs/agents/plans/) | Implementation plans for ongoing or upcoming features. |
| [Issues](docs/agents/issues/) | Detailed specs for open issues. |

### Issues (`docs/agents/issues/`)

Each file documents an issue in detail. Naming convention:

```
docs/agents/issues/<issue_id>_<issue_name>.md
```

Example: `docs/agents/issues/5_release_docker_image.md` for issue #5.

### Plans (`docs/agents/plans/`)

Each plan is a directory named after the issue ID and topic, containing one or more related files:

```
docs/agents/plans/<issue_id>_<topic>/<related_files>.md
```

Example: `docs/agents/plans/12_add-auth/plan.md` for issue #12.

## Commit Attribution

Commit co-author trailers follow arcanum's resolved `git.omit_model_coauthor` and `git.remove_coauthors` config (check them with `/arcanum-check-config`); this overrides Claude Code's own attribution reminder for every commit, including ones written by hand.
