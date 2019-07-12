# frozen_string_literal: true

module Arstotzka
  # @api private
  #
  # Class responsible to hold the options
  #
  # Options is initialized when using {ClassMethods#expose}
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
    # Creates a new instance of Options
    #
    # @param options_hash [Hash] options hash
    #   Options hash are initialized when using {ClassMethods#expose}
    #
    # @option (see ClassMethods#expose)
    #
    # @option options_hash instance [Object] instance whose method
    #   was called
    #
    # @option options_hash key [Symbol,String] name of method called.
    #   This will be used as instance variable when caching results
    #
    # @return [Arstotzka::Options]
    #
    # @see Config
    def initialize(options_hash)
      klass = options_hash.delete(:class)
      warn ":class has been deprecated, prefer 'expose klass: #{klass}'" if klass
      options_hash[:klass] ||= klass

      super(options_hash)
    end

    # @private
    #
    # Creates a new instance mergin the given hash with @options
    #
    # @return Arstotzka::Options
    def merge(options)
      self.class.new(to_h.merge(options))
    end

    # Retuns all keys used when fetching
    #
    # @return [Array<String>]
    def keys
      return full_path.split('.') if full_path
      return [key.to_s] unless path&.present?

      [path, key].compact.join('.').split('.')
    end

    # Checks if another instance equals self
    #
    # @param other [Object]
    #
    # @return [TrueClass,FalseClass]
    def ==(other)
      return false unless other.class == self.class
      to_h == other.to_h
    end
  end
end
