# frozen_string_literal: true

module Arstotzka
  # As Arstotzka extends ActiveSupport::Concern, Arstotzka::ClassMethods define
  # methods that will be available when defining a class that includes Arstotka
  module ClassMethods
    def fetcher_builders
      @fetcher_builders ||= {}
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
      fetcher_builders[attribute.to_sym].build(instance)
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
      MethodBuilder.new(attr_names, self, options).build
    end
  end
end
