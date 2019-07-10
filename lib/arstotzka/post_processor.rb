# frozen_string_literal: true

module Arstotzka
  class PostProcessor
    include Base

    def initialize(options_hash = {})
      self.options = options_hash
    end

    def process(value)
      value.flatten! if flatten && value.is_a?(Array)
      after ? instance.send(after, value) : value
    end

    private

    attr_reader :options
    delegate :instance, :after, :flatten, to: :options
  end
end
