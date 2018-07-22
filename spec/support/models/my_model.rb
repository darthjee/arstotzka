# frozen_string_literal: true

class MyModel
  attr_reader :json

  def initialize(json)
    @json = json
  end
end
