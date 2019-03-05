# frozen_string_literal: true

module Arstotzka
  # @api public
  #
  # Concern with all the type cast methods to be used by {Wrapper}
  #
  # Usage of typecast is defined by the configuration of {Builder} by the usage of
  # option type
  #
  # TypeCast can also be extended to include more types
  #
  # Supported types:
  # - integer
  # - string
  # - float
  #
  # @example Casting basic fields
  #   class TypeCaster
  #     include Arstotzka
  #
  #     expose :age,     type: :integer, json: :@hash
  #     expose :payload, type: :string, json: :@hash
  #     expose :price,   type: :float, json: :@hash
  #
  #     def initialize(hash)
  #       @hash = hash
  #     end
  #   end
  #
  #   hash = {
  #     age: '10',
  #     payload: { 'key' => 'value' },
  #     price: '1.75'
  #   }
  #
  #   model = TypeCaseter.new(hash)
  #
  #   model.age     # returns 10
  #   model.payload # returns '{"key"=>"value"}'
  #   model.price   # returns 1.75
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

    # converts a value to integer
    #
    # @return [Integer]
    def to_integer(value)
      value.to_i if value.present?
    end

    # converts value to string
    #
    # @return [String]
    def to_string(value)
      value.to_s
    end

    # converts value to float
    #
    # @return [Float]
    def to_float(value)
      value.to_f if value.present?
    end
  end
end
