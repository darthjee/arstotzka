# frozen_string_literal: true

class ShoppingMall
  include Arstotzka

  expose :customers, path: 'floors.stores',
                     flatten: true, json: :hash

  def initialize(hash)
    @hash = hash
  end

  private

  attr_reader :hash
end
