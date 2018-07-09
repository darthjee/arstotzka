# frozen_string_literal: true

class Game
  include Arstotzka
  include SafeAttributeAssignment
  attr_reader :json

  expose :name, :publisher

  def initialize(json)
    @json = json
  end
end
