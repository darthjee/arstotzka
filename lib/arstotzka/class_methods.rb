# frozen_string_literal: true

module Arstotzka
  # As Arstotzka extends ActiveSupport::Concern, Arstotzka::ClassMethods define
  # methods that will be available when defining a class that includes Arstotka
  module ClassMethods
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
    # @return nil
    #
    # @see Builder Arstotzka::Builder
    # @see
    #   https://www.rubydoc.info/gems/activesupport/5.2.2/ActiveSupport/Concern
    #   ActiveSupport::Concern
    def expose(*attr_names, **options)
      options = Builder::DEFAULT_OPTIONS.merge(options.symbolize_keys)
      Builder.new(attr_names, self, options).build
    end
  end
end
