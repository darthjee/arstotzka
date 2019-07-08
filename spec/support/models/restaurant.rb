# frozen_string_literal: true

class Restaurant
  include Arstotzka

  expose :dishes, path: 'restaurant.complete_meals'

  def initialize(hash)
    @hash = hash
  end
end
