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
    # @see MethodBuilder Arstotzka::MethodBuilder
    # @see
    #   https://www.rubydoc.info/gems/activesupport/5.2.2/ActiveSupport/Concern
    #   ActiveSupport::Concern
    def expose(*attr_names, **options_hash)
      options = Options.new(options_hash.symbolize_keys)
      MethodBuilder.new(attr_names.map(&:to_sym), self, options).build
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
