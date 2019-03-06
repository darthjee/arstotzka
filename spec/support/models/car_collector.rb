# frozen_string_literal: true

module Arstotzka
  module TypeCast
    def to_car(hash)
      Car.new(hash.symbolize_keys)
    end
  end
end

class CarCollector
  include Arstotzka

  attr_reader :json

  expose :cars, full_path: 'cars.unit', type: :car
  def initialize(hash)
    @json = hash
  end
end
