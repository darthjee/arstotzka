# frozen_string_literal: true

module Arstotzka
  # @api private
  #
  # Class responsible to hold the options
  #
  # Options is initialized and merged with {DEFAULT_OPTIONS}
  # when using {ClassMethods#expose}
  #
  # @example Using options klass and after
  #   class Customer
  #     attr_reader :name, :age
  #
  #     def initialize(name:, age:)
  #       @name = name
  #       @age  = age
  #     end
  #
  #     def adult?
  #       age >= 18
  #     end
  #   end
  #
  #   class Store
  #     include Arstotzka
  #
  #     expose :customers, klass: Customer, after: :filter_adults
  #
  #     def initialize(json)
  #       @json = json
  #     end
  #
  #     private
  #
  #     attr_reader :json
  #
  #     def filter_adults(values)
  #       values.select(&:adult?)
  #     end
  #   end
  #
  #   hash = {
  #     customers: [{
  #       name: 'John', age: 21
  #     }, {
  #       name: 'Julia', age: 15
  #     }, {
  #       name: 'Carol', age: 22
  #     }, {
  #       name: 'Bobby', age: 12
  #     }]
  #   }
  #
  #   instance = Store.new(hash)
  #
  #   instance.customers # returns [
  #                      #   Customer.new(name: 'John', age: 21),
  #                      #   Customer.new(name: 'Carol', age: 22)
  #                      # ]
  #
  # @example Using type with klass and after_each
  #   module Arstotzka::TypeCast
  #     def to_symbolized_hash(value)
  #       value.symbolize_keys
  #     end
  #   end
  #
  #   class Drink
  #     attr_reader :name, :price
  #
  #     def initialize(name:, price:)
  #       @name  = name
  #       @price = price
  #     end
  #
  #     def inflate(inflation)
  #       @price = (price * (1 + inflation)).round(2)
  #     end
  #   end
  #
  #   class Bar
  #     include Arstotzka
  #
  #     expose :drinks, type: :symbolized_hash,
  #       klass: Drink, after_each: :add_inflation
  #
  #     def initialize(json)
  #       @json = json
  #     end
  #
  #     private
  #
  #     attr_reader :json
  #
  #     def add_inflation(drink)
  #       drink.inflate(0.1)
  #       drink
  #     end
  #   end
  #
  #   json = '{"drinks":[{"name":"tequila","price":7.50},{ "name":"vodka","price":5.50}]}'
  #
  #   hash = JSON.parse(hash)
  #
  #   instance = Bar.new(hash)
  #
  #   instance.drinks # returns [
  #                   #   Drink.new(name: 'tequila', price: 8.25),
  #                   #   Drink.new(name: 'vodka', price: 6.05)
  #                   # ]
  #
  # @example Using cached, compact, after and full_path
  #   class Person
  #     attr_reader :name
  #
  #     def initialize(name)
  #       @name = name
  #     end
  #   end
  #
  #   class Application
  #     include Arstotzka
  #
  #     expose :users, full_path: 'users.first_name',
  #                    compact: true, cached: true,
  #                    after: :create_person
  #
  #     def initialize(json)
  #       @json = json
  #     end
  #
  #     private
  #
  #     attr_reader :json
  #
  #     def create_person(names)
  #       names.map do |name|
  #         warn "Creating person #{name}"
  #         Person.new(name)
  #       end
  #     end
  #   end
  #
  #   # Keys are on camel case (lower camel case)
  #   hash = {
  #     users: [
  #       { firstName: 'Lucy',  email: 'lucy@gmail.com' },
  #       { firstName: 'Bobby', email: 'bobby@hotmail.com' },
  #       { email: 'richard@tracy.com' },
  #       { firstName: 'Arthur', email: 'arthur@kamelot.uk' }
  #     ]
  #   }
  #
  #   instance = Application.new(hash)
  #
  #   instance.users # trigers the warn "Creating person <name>" 3 times
  #                  # returns [
  #                  #   Person.new('Lucy'),
  #                  #   Person.new('Bobby'),
  #                  #   Person.new('Arthur')
  #                  # ]
  #   instance.users # returns the same value, without triggering warn
  #
  # @example Working with snake case hash
  #   class JobSeeker
  #     include Arstotzka
  #
  #     expose :applicants, case: :snake, default: 'John Doe',
  #                         full_path: 'applicants.full_name',
  #                         compact: true, json: :@hash
  #
  #     def initialize(hash)
  #       @hash = hash
  #     end
  #   end
  #
  #   hash = {
  #     'applicants' => [
  #       {
  #         'full_name' => 'Robert Hatz',
  #         'email' => 'robert.hatz@gmail.com'
  #       }, {
  #         'full_name' => 'Marina Wantz',
  #         'email' => 'marina.wantz@gmail.com'
  #       }, {
  #         'email' => 'albert.witz@gmail.com'
  #       }
  #     ]
  #   }
  #
  #   instance = JobSeeker.new(hash)
  #
  #   instance.applicants # returns [
  #                       #   'Robert Hatz',
  #                       #   'Marina Wantz',
  #                       #   'John Doe'
  #                       # ]
  #
  # @example Deep path with flatten option
  #   class ShoppingMall
  #     include Arstotzka
  #
  #     expose :customers, path: 'floors.stores',
  #                        flatten: true, json: :hash
  #
  #     def initialize(hash)
  #       @hash = hash
  #     end
  #
  #     private
  #
  #     attr_reader :hash
  #   end
  #
  #   hash = {
  #     floors: [{
  #       name: 'ground', stores: [{
  #         name: 'Starbucks', customers: %w[
  #           John Bobby Maria
  #         ]
  #       }, {
  #         name: 'Pizza Hut', customers: %w[
  #           Danny LJ
  #         ]
  #       }]
  #     }, {
  #       name: 'first', stores: [{
  #         name: 'Disney', customers: %w[
  #           Robert Richard
  #         ]
  #       }, {
  #         name: 'Comix', customers: %w[
  #           Linda Ariel
  #         ]
  #       }]
  #     }]
  #   }
  #
  #   instance = ShoppingMall.new(hash)
  #
  #   instance.customers # returns %w[
  #                      #   John Bobby Maria
  #                      #   Danny LJ Robert Richard
  #                      #   Linda Ariel
  #                      # ]
  class Options < ::OpenStruct
    DEFAULT_OPTIONS = {
      after:      false,
      after_each: nil,
      cached:     false,
      case:       :lower_camel,
      compact:    false,
      default:    nil,
      flatten:    false,
      full_path:  nil,
      json:       :json,
      klass:      nil,
      path:       nil,
      type:       :none
    }.freeze

    # Creates a new instance of Options
    #
    # @param options [Hash] options hash
    #
    #   Options hash are initialized and merged with {DEFAULT_OPTIONS}
    #   when using {ClassMethods#expose}
    #
    # @option options [String,Symbol] after: {Fetcher} option with the name of the method to be
    #   called once the value is fetched for mapping the value
    #
    # @option options [String,Symbol] after_each: {Wrapper} option with method that will be called
    #   on each individual result (while after is called on the whole collection)
    # @option options [Boolean] cached: flag if the result should be memorized instead of repeating
    #   the crawling
    # @option options [String,Symbol] case: {Reader} flag definining on which case will
    #   the keys be defined
    #   - lower_camel: keys in the hash are lowerCamelCase
    #   - upper_camel: keys in the hash are UpperCamelCase
    #   - snake: keys in the hash are snake_case
    # @option options [Boolean] compact: {Crawler} flag to apply Array#compact thus
    #   removing nil results
    # @option options [Boolean] default: {Crawler} option to return default value instead of nil
    # @option options [Boolean] flatten: {Fetcher} flag to aplly Array#flatten thus
    #   avoing nested arrays
    # @option options [String,Symbol] full_path: path of hash attributes to find exacttly where the
    #   value live (ignoring the attribute name)
    # @option options [Class] klass: {Fetcher} option that, when passed, wraps the individual
    #   results in an instance of the given class
    # @option options [String,Symbol] json: name of the method containing the hash to be crawled
    # @option options [String,Symbol] path path of hash attributes to find the root
    #   where the attribute live (then fetching it using the attribute name)
    # @option options [String,Symbol] type:  {Fetcher} option declaring the type of the returned
    #   value (to use casting) (see {TypeCast})
    #   - integer
    #   - string
    #   - float
    #
    # @see Arstotzka::Options::DEFAULT_OPTIONS
    # @return [Arstotzka::Options]
    def initialize(options)
      klass = options.delete(:class)
      warn ":class has been deprecated, prefer 'expose klass: #{klass}'" if klass
      options[:klass] ||= klass

      super(DEFAULT_OPTIONS.merge(options))
    end

    # @private
    #
    # Creates a new instance mergin the given hash with @options
    #
    # @return Arstotzka::Options
    def merge(options)
      self.class.new(to_h.merge(options))
    end

    def keys
      return full_path.split('.') if full_path
      return [key.to_s] unless path&.present?

      [path, key].compact.join('.').split('.')
    end

    def ==(other)
      return false unless other.class == self.class
      options == other.options
    end
  end
end
