# frozen_string_literal: true

module Arstotzka
  class FetcherBuilder
    include Base

    def initialize(instance, options_hash = {})
      self.options = options_hash

      @instance = instance
    end

    def build(hash)
      Fetcher.new(hash, instance, options)
    end

    private

    attr_reader :options, :instance
  end
end
