# frozen_string_literal: true

class Bar
  include Arstotzka

  expose :drinks, type: :symbolized_hash,
                  klass: Drink, after_each: :add_inflation

  def initialize(json)
    @json = json
  end

  private

  attr_reader :json

  def add_inflation(drink)
    drink.inflate(0.1)
    drink
  end
end
