# frozen_string_literal: true

class Request
  attr_reader :payload

  def initialize(payload)
    @payload = payload
  end
end
