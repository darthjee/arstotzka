# Architecture

## Overview

Arstotzka is a Ruby concern (`ActiveSupport::Concern`). A class does `include Arstotzka`
and declares attributes with the class method `expose`. Each exposed attribute becomes a
real instance method (built with [Sinclair](https://github.com/darthjee/sinclair)) that,
when called, builds a `Fetcher` which reads the instance's hash, crawls it through a
path of keys, wraps/casts the values found and post-processes the result.

Options flow through the whole pipeline as a single `Arstotzka::Options` object, created
from the global defaults in `Arstotzka::Config` merged with the options given to `expose`
(and the owning `instance`). Every internal class receives these options in its
constructor and reads only what it needs.

Most classes are marked `@api private`; the public API is `Arstotzka` itself,
`ClassMethods#expose`, `Arstotzka.configure` / `Config`, and `TypeCast` (which users may
extend with custom `to_<type>` methods).

## Source Code Layout

All source code lives under `lib/`. `lib/arstotzka.rb` defines the concern and
autoloads every class in `lib/arstotzka/`.

### Declaration (class level)

| File | Role |
|------|------|
| `class_methods.rb` | `ClassMethods#expose` (public) plus the per-class registry of `FetcherBuilder`s (`add_fetcher`, `fetcher_for`, `builder_for`), inherited by subclasses. |
| `method_builder.rb` | `MethodBuilder < Sinclair` — registers a `FetcherBuilder` for each attribute and defines the reader method calling `fetcher_for(attr, self).fetch`. |
| `fetcher_builder.rb` | Holds an attribute's options and builds a `Fetcher` bound to a given instance. |
| `config.rb` | `Config < Sinclair::Config` — global defaults for `expose` options; builds `Options` objects. |
| `options.rb` | `Options < Sinclair::Options` — value object with every supported option (`path`, `full_path`, `json`, `type`, `klass`, `cached`, `case`, `compact`, `flatten`, `default`, `after`, `after_each`, `before`, ...). Documents each option. |

### Fetching (instance level)

| File | Role |
|------|------|
| `fetcher.rb` | Orchestrates a fetch: cache → read hash → crawl (with wrapping) → post-process. |
| `fetcher/cache.rb` | Handles the `cached` option, storing the result in an instance variable. |
| `hash_reader.rb` | Retrieves the hash to crawl from the instance (via the `json` option: method, instance variable or class variable). |
| `crawler.rb` | Recursively walks the hash through the keys, descending into arrays, applying `default`/`compact` and calling the wrapper block on final values. |
| `reader.rb` | Reads the value for the key at a given index of the key path; raises `KeyNotFound` when missing. |
| `key_reader.rb` | Reads a single key from a hash, trying string and symbol forms. |
| `key_changer.rb` | Converts a key to the configured case (`lower_camel`, `upper_camel`, `snake`). |
| `wrapper.rb` | Per-element transformation: `before`, type casting, wrapping in `klass`, `after_each`. |
| `type_cast.rb` | `to_integer`, `to_float`, `to_string`, `to_symbol` casts; extendable by users. |
| `post_processor.rb` | Collection-level processing of the crawled result: `flatten`, then `after` method call. |

### Support

| File | Role |
|------|------|
| `base.rb` | Shared helper for classes that receive an `options` object. |
| `exception.rb` | `Exception::KeyNotFound` and `Exception::FetcherBuilderNotFound`. |
| `version.rb` | Gem version (`Arstotzka::VERSION`). |

## Code Style

- Small, single-responsibility classes, each initialised with an options object/hash.
- Memoised collaborators (`@crawler ||= Crawler.new(options)`).
- Public methods first, then `protected`/`private`; delegation via `ActiveSupport` `delegate`.
- Every method, including private ones, carries YARD documentation with `@api` tags and
  `@example` blocks; examples are verified by `spec/integration/yard`.
