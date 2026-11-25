# Flow

## Overview

### Declaration (class load time)

1. `include Arstotzka` extends the class with `Arstotzka::ClassMethods`.
2. `expose :attr, **options` creates an `Arstotzka::MethodBuilder` with the attribute names
   and options.
3. For each attribute, `MethodBuilder` registers a `FetcherBuilder` in the class
   (`add_fetcher`) and defines the instance method `attr`.

### Fetching (method call time)

1. `instance.attr` calls `self.class.fetcher_for(:attr, self)`, which finds the
   `FetcherBuilder` (looking up superclasses) and builds a `Fetcher` with
   `Arstotzka.config.options(options.merge(instance: self))`.
2. `Fetcher#fetch` goes through `Fetcher::Cache`: if `cached` is set and a value is
   already stored, it is returned.
3. Otherwise `HashReader` gets the hash from the instance (the `json` option).
4. `Crawler#value` walks the keys (`path` + attribute name, or `full_path`), using `Reader`
   → `KeyReader` → `KeyChanger` to read each key in the configured case. Arrays are
   crawled element by element; missing keys yield `default`, and `compact` drops `nil`s.
5. Each final value passes through `Wrapper#wrap`: `before`, type cast (`TypeCast`),
   wrapping in `klass`, and `after_each`.
6. `PostProcessor#process` applies `flatten` and calls the instance's `after` method on
   the whole result.
7. The result is cached (if requested) and returned.
