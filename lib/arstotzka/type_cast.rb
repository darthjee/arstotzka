# frozen_string_literal: true

module Arstotzka
  # @api public
  #
  # Concern with all the type cast methods to be used by {Wrapper}
  #
  # Usage of typecast is defined by the configuration of {MethodBuilder} by the usage of
  # option type
  #
  # TypeCast can also be extended to include more types
  #
  # Supported types:
  # - integer
  # - string
  # - float
  # - symbol
  #
  # @example (see #to_integer)
  #
  # @example (see #to_string)
  #
  # @example (see #to_float)
  #
  # @example (see #to_symbol)
  #
  # @example Extending typecast
  #   class Car
  #     attr_reader :model, :maker
  #
  #     def initialize(model:, maker:)
  #       @model = model
  #       @maker = maker
  #     end
  #   end
  #
  #   module Arstotzka
  #     module TypeCast
  #       def to_car(hash)
  #         Car.new(hash.symbolize_keys)
  #       end
  #     end
  #   end
  #
  #   class CarCollector
  #     include Arstotzka
  #
  #     attr_reader :json
  #
  #     expose :cars, full_path: 'cars.unit', type: :car
  #
  #     def initialize(hash)
  #       @json = hash
  #     end
  #   end
  #
  #   hash = {
  #     cars: [{
  #       unit: { model: 'fox', maker: 'volkswagen' }
  #     }, {
  #       unit: { 'model' => 'focus', 'maker' => 'ford' }
  #     }]
  #   }
  #
  #   model = CarCollector.new(hash)
  #
  #   model.cars              # returns [<Car>, <Car>]
  #   model.cars.map(&:model) # returns ['fox', 'focus']
  module TypeCast
    extend ActiveSupport::Concern

    # Converts a value to integer
    #
    # @param value [Object] object to be converted
    #   to integer
    #
    # @return [Integer]
    #
    # @example Casting to Integer
    #   class TypeCaster
    #     include Arstotzka
    #
    #     expose :age, type: :integer, json: :@hash
    #
    #     def initialize(hash)
    #       @hash = hash
    #     end
    #   end
    #
    #   hash = {
    #     age: '10',
    #   }
    #
    #   TypeCaster.new(age: '10').age
    def to_integer(value)
      value.to_s.to_i if value.present?
    end

    # Converts value to string
    #
    # @param value [Object] object to be converted
    #   to string
    #
    # @return [String]
    #
    # @example Casting to String
    #   class TypeCaster
    #     include Arstotzka
    #
    #     expose :payload, type: :string, json: :@hash
    #
    #     def initialize(hash)
    #       @hash = hash
    #     end
    #   end
    #
    #   hash = {
    #     payload: { 'key' => 'value' },
    #   }
    #
    #   model.TypeCaster.new(hash)
    #
    #   model.payload # returns '{"key"=>"value"}'
    def to_string(value)
      value.to_s
    end

    # Converts value to float
    #
    # @param value [Object] object to be converted
    #   to float
    #
    # @return [Float]
    #
    # @example Casting to Float
    #   class TypeCaster
    #     include Arstotzka
    #
    #     expose :price, type: :float, json: :@hash
    #
    #     def initialize(hash)
    #       @hash = hash
    #     end
    #   end
    #
    #   hash = {
    #     price: '1.75'
    #   }
    #
    #   TypeCaster.new(price: '1.75').price # returns 1.75
    def to_float(value)
      value.to_s.to_f if value.present?
    end

    # Converts value to Symbol
    #
    # @param value [Object] object to be converted
    #   to symbol
    #
    # @return [Symbol]
    #
    # @example Casting to Symbol
    #   class TypeCaster
    #     include Arstotzka
    #
    #     expose :type, type: :symbol, json: :@hash
    #
    #     def initialize(hash)
    #       @hash = hash
    #     end
    #   end
    #
    #   hash = {
    #     type: 'type_a'
    #   }
    #
    #   TypeCaster.new(type: 'type_a').type # returns :type_a
    def to_symbol(value)
      value.to_s.to_sym if value.present?
    end
  end
end
