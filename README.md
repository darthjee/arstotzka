Arstotzka
========
[![Build Status](https://circleci.com/gh/darthjee/arstotzka.svg?style=shield)](https://circleci.com/gh/darthjee/arstotzka)
[![Code Climate](https://codeclimate.com/github/darthjee/arstotzka/badges/gpa.svg)](https://codeclimate.com/github/darthjee/arstotzka)
[![Test Coverage](https://codeclimate.com/github/darthjee/arstotzka/badges/coverage.svg)](https://codeclimate.com/github/darthjee/arstotzka/coverage)
[![Issue Count](https://codeclimate.com/github/darthjee/arstotzka/badges/issue_count.svg)](https://codeclimate.com/github/darthjee/arstotzka)
[![Gem Version](https://badge.fury.io/rb/arstotzka.svg)](https://badge.fury.io/rb/arstotzka)
[![Inline docs](http://inch-ci.org/github/darthjee/arstotzka.svg)](http://inch-ci.org/github/darthjee/arstotzka)

![arstotzka](https://raw.githubusercontent.com/darthjee/arstotzka/master/arstotzka.jpg)

This project allows for a quick hash / json data fetching in order to avoid code
that tries to crawl through a hash and has to constantly check for nil values or missing keys

also, this concern, like openstruct, allow the json to be manipulated as an object, but
avoids method missing by aways having the declarated methods, even if that means nil return

Arstotzka is also usefull when you need keys case changed or data type cast as it was developed
to be a bridge between a rails application and a Java API (Java APIs use cameCase for
JSON keys)

Yard Documentation
-------------------
[https://www.rubydoc.info/gems/arstotzka/1.6.2](https://www.rubydoc.info/gems/arstotzka/1.6.2)

Instalation
---------------
1. Add Arstotzka to your `Gemfile` and `bundle install`:
  - Install it

```ruby
  gem install arstotzka
```

- Or add Arstotka to you `Gemfile` and `bundle install`

```ruby
gem 'arstotzka'
```

```bash
  bundle install arstotzka
```

Getting Started
---------------
1. Include in a class that you want to wrap a json/hash

```ruby
class MyParser
  include Arstotzka
end
```

2. Declare the keys you want to crawl

```ruby
class MyParser
  include Arstotzka

  expose :id
  expose :name, :age, path: :person

  attr_reader :json

  def initialize(json = {})
    @json = json
  end
end

```

and let it fetch values from your hash


```ruby
MyParser.new(
  id: 10,
  age: 22
  person: {
    name: 'Robert',
    age: 22
  }
)
```

this is usefull when trying to fetch data from hashes missing nodes

```ruby
MyParser.new.name # returns nil
```

3. fully customise the way you crawl / fetch the information with [Options](#options)

4. Create custom [typecast](#TypeCast)

Options
-------
- after: Name of a method to be called after on the values returned
- after_each: Name of a method to be called after each result
- cached: Indicator that, once the value has been fetched, it should be cached (false by default)
  - false : no cache
  - true : simple cache where nil values are not considerated cached
  - :full : full cache where even nil values are cached
- case: Case of the keys from the json (lower_camel by default)
  - :snake : snakecase (eg. `the_key`)
  - :lower_camel : lower cammel case (eg. `theKey`)
  - :upper_camel : upper cammel case (eg. `TheKey`)
- compact: Indicator telling to ignore nil values inside array (false by default)
- default: Default value (prior to casting and wrapping, see [Default](#default))
- flatten: Indicator telling that to flattern the resulting array (false by default)
- full_path: Full path to fetch the value (empty by default)
- klass: Class to be used when wrapping the final value
- json: Method that contains the hash to be parsed (`:json` by default)
- path: Path where to find the sub hash that contains the key (empty by default)
- type: Type that the value must be cast into ([TypeCast](#typecast))
- before: method to be ran on result before any wrapping

## TypeCast
The type casting, when the option `type` is passed, is done through the `Arstotzka::TypeCast` which can
be extended

```ruby
module Arstotzka::TypeCast
  def to_money_float(value)
    value.gsub(/\$ */, '').to_f
  end
end
```

```ruby
class MyParser
  include Arstotzka

  expose :total_money, full_path: 'accounts.balance', after: :sum,
                       cached: true, type: :money_float
  expose :total_owed, full_path: 'loans.value', after: :sum,
                       cached: true, type: :money_float

  attr_reader :json

  def initialize(json = {})
    @json = json
  end

  private

  #this method will receive the array of values resulting from the initial mapping
  def sum(balances)
    balances.sum if balances
  end
end
```

```ruby
object = MyParser.new(
  accounts: [
    { balance: '$ 1000.50', type: 'checking' },
    { balance: '$ 150.10', type: 'savings' },
    { balance: '$ -100.24', type: 'checking' }
  ],
  loans: [
    { value: '$ 300.50', bank: 'the_bank' },
    { value: '$ 150.10', type: 'the_other_bank' },
    { value: '$ 100.24', type: 'the_same_bank' }
  ]
)

object.total_money # returns 1050.36
```

## Default
Default value returned before typecasting or class wrapping

```ruby
class Star
  attr_reader :name

  def initialize(name:)
    @name = name
  end
end

class StarGazer
  include Arstotzka

  expose :favorite_star, full_path: 'universe.star',
         default: { name: 'Sun' }, klass: ::Star

  attr_reader :json

  def initialize(json = {})
    @json = json
  end
end

```

```ruby
star_gazer = StarGazer.new

star_gazer.favorite_star.name # returns "Sun"

star_gazer.favorite_star.class # returns Star
```

Configuration
-------------
Arstotzka can be configured changing the default options

```ruby
class Restaurant
  include Arstotzka

  expose :dishes, path: 'restaurant.complete_meals'

  def initialize(hash)
    @hash = hash
  end
end

hash = {
  restaurant: {
    complete_meals: {
      dishes: %w[
        Goulash
        Spaghetti
        Pizza
      ]
    }
  }
}

restaurant = Restaurant.new(hash)
restaurant.dishes # raises NoMethodError as json method is
                  # is not defined in Restaurant

Arstotzka.configure { json :@hash }

restaurant.dishes # returns nil as default case is lower_camel

Arstotzka.configure { |c| c.case :snake }

restaurant.dishes # return %s[Goulash Spaghetti Pizza]
```
