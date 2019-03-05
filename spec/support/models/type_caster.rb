# frozen_string_literal: true

class TypeCaster
  include Arstotzka

  expose :age,     type: :integer, json: :@hash
  expose :payload, type: :string, json: :@hash
  expose :price,   type: :float, json: :@hash

  def initialize(hash)
    @hash = hash
  end
end
