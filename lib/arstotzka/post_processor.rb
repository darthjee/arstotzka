# frozen_string_literal: true

module Arstotzka
  class PostProcessor
    include Base

    def process(value)
      value.flatten! if flatten && value.is_a?(Array)

      return value unless after

      instance.send(after, value)
    end

    private

    attr_reader :options

    delegate :instance, :after, :flatten, to: :options
  end
end
