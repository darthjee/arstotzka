# frozen_string_literal: true

module Arstotzka
  class FetcherBuilder
    include Base

    def initialize(options_hash = {})
      self.options = options_hash
    end

    def build(instance)
      Fetcher.new(instance, options)
    end

    private

    attr_reader :options
    delegate :json, :key, :path, :full_path, to: :options
  end
end
