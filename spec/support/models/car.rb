# frozen_string_literal: true

class Car
  attr_reader :model, :maker

  def initialize(model:, maker:)
    @model = model
    @maker = maker
  end
end
