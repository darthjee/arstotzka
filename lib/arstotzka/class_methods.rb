# frozen_string_literal: true

module Arstotzka
  # As Arstotzka extends ActiveSupport::Concern, Arstotzka::ClassMethods define
  # methods that will be available when defining a class that includes Arstotka
  module ClassMethods
    # @api private
    #
    # Create builder that will be used to create Fetchers
    #
    # @param attribute [Symbol,String] attribute key
    # @param options [Arstotzka::Options] fetcher options
    #
    # @return [Artotzka::FetcherBuilder]
    def add_fetcher(attribute, options = {})
      fetcher_builders[attribute] = FetcherBuilder.new(options.merge(key: attribute))
    end

    # @api private
    #
    # Return the fetcher for an attribute and instance
    #
    # a new fetcher is built everytime this method is called
    #
    # @param attribute [Symbol,String] Name of method that will use this Fetcher
    # @param instance [Object] instance that will contain the Hash needed by fetcher
    #
    # @return [Arstotzka::Fetcher]
    def fetcher_for(attribute, instance)
      return builder_for(attribute).build(instance) if fetcher_for?(attribute)

      raise Exception::FetcherBuilderNotFound.new(attribute, self)
    end

    protected

    # @api private
    #
    # Checks if class can build a fetcher for attribute
    #
    # @param attribute [::Symbol]
    #
    # @return [TrueClass,FalseClass]
    def fetcher_for?(attribute)
      return true if fetcher_builders.key?(attribute)
      return unless superclass.include?(Arstotzka)

      superclass.fetcher_for?(attribute)
    end

    # @api private
    #
    # Returns fetcher builder for an attribute
    #
    # @param attribute [::Symbol]
    #
    # @return [Arstotzka::FetcherBuilder]
    def builder_for(attribute)
      builder = fetcher_builders[attribute]
      return superclass.builder_for(attribute) unless builder

      builder
    end

    private

    # @api public
    # @!visibility public
    #
    # Expose a field from the json/hash as a method
    #
    # @param attr_names [Array<String,Symbol>] attributes being exposed
    # @param options_hash [Hash] exposing options
    #
    # @option options_hash after [String,Symbol] instance method to be called on the
    #   returning value returned by {Crawler} before being returned by {Fetcher}.
    #   The result of the method call will be the actual value
    #   (used by {PostProcessor})
    #
    # @option options_hash after_each [String,Symbol] instance method to be
    #   called on each element found when crawling the hash.
    #   If an array should be returned, after_each will be called on each individual
    #   elements (even nil elements) while +after+ is only called on the
    #   collection. (used by {Wrapper})
    #
    # @option options_hash cached [Boolean,Symbol] Flag to ensure
    #   there value is cached after first fetching.
    #   (used by {Fetcher::Cache})
    #   - +false+/+nil+ : no cache, fetcher will always look in the hash
    #     for the value
    #   - +true+ : Simple cache, nil values are always considered
    #     not cached
    #   - +:full+ : cache even nil values
    #
    # @option options_hash case [Symbol] case type of the keys in the hash
    #   (used by {KeyChanger})
    #   - +:snake+ : snake_cased keys
    #   - +:lower_camel+ : lowerCamelCased keys
    #   - +:upper_camel+ : UperCamelCased keys
    #
    # @option options_hash compact [Boolean] flag signallying if nil values should be
    #   removed of array (applying +Array#compact+) (used by {Crawler})
    #
    # @option options_hash default [Object] default value to be returned when failing
    #   to fetch a value (used by {Crawler})
    #
    # @option options_hash flatten [Boolean] flag signallying if multi levels
    #   arrays should be flattened to one level array (applying +Array#flatten+)
    #   (used by {PostProcessor})
    #
    # @option options_hash full_path [String] full path of keys to be used in when
    #   not wanting to have the attribute defined as key. (eg. +'person.name'+)
    #   (used by {Crawler})
    #
    # @option options_hash klass [Class] class to wrap the value (used by {Wrapper})
    #
    # @option options_hash json [String,Symbol] name of the method or variable
    #   used to fetch the hash to be crawled (eg. +:hash+, +:@hash+, +"@@config"+)
    #   (used by {HashReader})
    #
    # @option options_hash path [String,Symbol] base path to be crawled.
    #   (used by {Crawler})
    #
    # @option options_hash type [String,Symbol] type to cast the value. The
    #   possible type_cast is defined by {TypeCast} (used by {Wrapper})
    #   - +integer+
    #   - +string+
    #   - +float+
    #
    # @example
    #   class MyModel
    #     include Arstotzka
    #
    #     attr_reader :json
    #
    #     expose :first_name, full_path: 'name.first'
    #     expose :age, 'cars', type: :integer
    #
    #     def initialize(json)
    #       @json = json
    #     end
    #   end
    #
    #   instance = MyModel.new(
    #     'name' => { first: 'John', last: 'Williams' },
    #     :age => '20',
    #     'cars' => 2.0
    #   )
    #
    #   instance.first_name # returns 'John'
    #   instance.age        # returns 20
    #   instance.cars       # returns 2
    #
    # @return [Array<Sinclair::MethodDefinition>]
    #
    # @see Config
    # @see MethodBuilder Arstotzka::MethodBuilder
    # @see
    #   https://www.rubydoc.info/gems/activesupport/5.2.2/ActiveSupport/Concern
    #   ActiveSupport::Concern
    def expose(*attr_names, **options_hash)
      MethodBuilder.new(attr_names.map(&:to_sym), self, options_hash).build
    end

    # @private
    # @api private
    #
    # Map of FetcherBuilders
    #
    # @return [Hash<FetcherBuilder>]
    def fetcher_builders
      @fetcher_builders ||= {}
    end
  end
end
