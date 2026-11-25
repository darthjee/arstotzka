# Contributing

## Commit Guidelines

- **Atomic and Unitary:** Each commit must represent a single logical change.
  *Example:*
  - Good: `Add before option to Wrapper`
  - Bad: `Add before option and refactor Crawler logic`
- **No Unrelated Changes:** Do not mix unrelated changes in the same commit.
- **Separate Refactoring:** Whenever possible, separate refactoring commits from new feature or bugfix commits.

## Pull Requests

- **Descriptive Summary:** Every PR must include a clear and descriptive summary of its purpose and changes.
- **PR Description Files:** If a description cannot be provided directly in the PR, generate a file with the PR description (e.g., `docs/agents/issues/<pr_number>_description.md`), but do not commit this file.

## Definition of Done for PRs

A PR is considered complete when:

- The stated objective has been achieved.
- All tests are passing.
- Linting (`rubocop`) passes without errors.
- Code coverage is as high as reasonably possible.
- New/changed public code is documented with YARD and Yardstick coverage does not drop.
- `@example` blocks added to YARD docs or `README.md` are covered by specs in
  `spec/integration/yard` or `spec/integration/readme`.
- When the version is bumped, `README.md` links the new version's YARD docs.
- Code is not overly complex:
  - Classes and methods should have clear, focused responsibilities.
  - If a class or method is taking on too many responsibilities, refactor to simplify.
  - Methods should be small and do exactly one thing. If a method is growing, extract parts into private helper methods or separate classes.
  - *Example:*

    ```ruby
    # Good: each method does one thing
    class Fetcher
      def fetch
        post_processor.process(crawler.value(hash))
      end

      private

      def crawler
        @crawler ||= Crawler.new(options)
      end
    end

    # Bad: one method does too much
    class Fetcher
      def fetch
        hash = options.instance.send(options.json)
        value = options.keys.inject(hash) { |h, key| h[key.to_s] || h[key.to_sym] }
        value = value.flatten if options.flatten
        options.instance.send(options.after, value)
      end
    end
    ```

  - This requirement applies primarily to source code. For specs, refactor only if there is excessive duplication.

### CI Checks

Before a PR is considered complete, all CI checks relevant to the modified parts of the project must pass locally.

The project has a single CircleCI `test` job, run for every change:

| Modified folder | CircleCI job | Local commands |
| --- | --- | --- |
| any (`lib/`, `spec/`, `config/`, `README.md`, ...) | `test` | `bundle exec rspec`<br>`rubocop`<br>`bundle exec rake verify_measurements` (Yardstick)<br>`scripts/check_readme.sh` (README links current version docs)<br>`bundle exec rubycritic --format console --branch origin/master -t 0 --maximum-decrease 1 <changed lib files>`<br>every `lib/` file has a spec under `spec/lib/` (`check_specs`, see `config/check_specs.yml`) |

The same can be run in Docker with `docker-compose run test_all` (RSpec + YARD + Yardstick)
plus `docker-compose run arstotzka rubocop`.

The `build-and-release` job only runs on version tags on `master` and needs no local check.

This same process must be followed when **planning how to resolve an issue**: include a final step in the plan that lists the CI commands to run before opening a PR.

## Code Organization

### File Responsibility: Class Declarers vs Scripts

Every source file under `lib/` must act as a **class declarer** — it should define one class or module. Files must not act as **scripts** (i.e., they must not execute logic at load time or perform side effects directly).

The only entrypoint is `lib/arstotzka.rb`, which requires dependencies, defines the
`Arstotzka` concern, autoloads the other classes and calls `configurable_by`.

*Example:*

```ruby
# Good: class declarer
module Arstotzka
  class KeyChanger
    def initialize(base_key, options_hash = {})
      ...
    end
  end
end

# Bad: script — executes logic at load time
changer = Arstotzka::KeyChanger.new('the_key', case: :lower_camel)
puts changer.key
```

Spec files are exempt from this rule and may execute setup code freely.

### File Naming: snake_case Matching the Class

Files use **snake_case** naming matching the class or module they define, and the
directory structure mirrors the namespace:

- `Arstotzka::KeyChanger` → `lib/arstotzka/key_changer.rb`
- `Arstotzka::Fetcher::Cache` → `lib/arstotzka/fetcher/cache.rb`

Specs mirror the source path with a `_spec.rb` suffix:

- `lib/arstotzka/key_changer.rb` → `spec/lib/arstotzka/key_changer_spec.rb`

New classes must also be registered with `autoload` in `lib/arstotzka.rb`.

### Method Order: Public Before Private

Within a class, **public methods must be declared before `protected` and `private` methods**. Private methods serve as implementation helpers and appear at the end of the class body.

*Example:*

```ruby
# Good: public methods first, private methods last
class Wrapper
  def wrap(value)
    return wrap_array(value) if value.is_a?(Array)

    wrap_element(value)
  end

  private

  def wrap_array(array) ... end
  def wrap_element(value) ... end
end

# Bad: private helpers mixed in before public methods
class Wrapper
  private

  def wrap_array(array) ... end

  public

  def wrap(value) ... end
end
```

## Dependency Injection

Classes must receive their dependencies (data, options, collaborators) as constructor arguments. A class must never reach out to load files, read environment variables, or fetch configuration on its own.

In Arstotzka, global configuration is resolved once — by `FetcherBuilder#build` via
`Arstotzka.config.options(...)` — and the resulting `Options` object (including the
`instance`) is passed down to every collaborator (`Fetcher`, `Crawler`, `Wrapper`, ...).

This makes every class independently testable: specs simply instantiate the class with the options they need.

*Example:*

```ruby
# Good: class receives options as an argument — easy to test
class Wrapper
  def initialize(options = {})
    @options = options
  end
end

Arstotzka::Wrapper.new(type: :integer).wrap('10') # => 10

# Bad: class reads global configuration on its own
class Wrapper
  def wrap(value)
    cast(value, Arstotzka.config.type) # ❌
  end
end
```

This principle applies to all classes — including helpers. If a class needs data, it gets it through its constructor.

## Refactoring Guidelines

When refactoring, aim to:

- **Reduce Code Duplication:**
  *Example:* Move repeated setup in specs to `let` blocks, shared examples
  (`spec/support/shared_examples`) or support models (`spec/support/models`).

  ```ruby
  # Good
  let(:options) { { path: 'person', case: :snake } }
  let(:fetcher) { described_class.new(options.merge(instance: instance)) }

  # Bad
  fetcher = described_class.new(path: 'person', case: :snake, instance: instance)
  # ...repeated in many examples
  ```
