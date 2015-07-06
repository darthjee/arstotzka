Json Parser
========

This project allows for a quick hash / json data fetching in order to avoid code
that tries to crawl through a hash and has to constantly check for nil values or missing keys

also, this concern, like openstruct, allow the json to be manipulated as an object, but
avoids method missing by aways having the declarated methods, even if that means nil return

Json Parser is also usefull when you need keys case changed or data type cast

Getting started
---------------
1. Add JsonParser to your `Gemfile` and `bundle install`:

    ```ruby
    gem 'json_parser'
    ```

2. Include in a class that you want to wrap a json/hash
  ```ruby
  class Parser
    include JsonParser

    attr_reader :json

    def initialize(json)
      @json = json
    end
  end
  ```

3. Declare the keys you want to crawl
  ```ruby
  class Parser
    json_parse :id, :dog_name, cached: true
    json_parse :age, type: :integer
  end
  ```

Options
-------
- path: path where to find the sub hash that contains the key (empty by default)
- json: method that contains the hash to be parsed (json by default)
- full_path: full path to fetch the value (empty by default)
- cached: indicator that once the value has been fetched, it should be cached (false by default)
- class: class to be used when wrapping the final value
- compact: indicator telling to ignore nil values inside array (false by default)
- flatten: indicator telling that to flattern the resulting array (false by default)
- after: name of a method to be called after with the resulting value
- case: case of the keys from the json (camel by default)
- type: Type that the value must be cast into
