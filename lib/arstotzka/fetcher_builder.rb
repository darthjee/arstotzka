# frozen_string_literal: true

module Arstotzka
  class FetcherBuilder
    include Base

    def initialize(instance, options_hash = {})
      self.options = options_hash

      @instance = instance
    end

    def build
      Fetcher.new(hash, instance, fetcher_options)
    end

    private

    attr_reader :options, :instance
    delegate :json, :key, :path, :full_path, to: :options

    # @private
    #
    # builds the complete key path to fetch value
    #
    # @return [String] the keys path
    def real_path
      full_path || [path, key].compact.join('.')
    end

    # @private
    #
    # Options needed by fetcher
    #
    # @return [Hash] options
    #
    # @see Arstotzka::Fetcher
    def fetcher_options
      options.merge(
        path: real_path
      )
    end

    def hash
      instance.send(json)
    end
  end
end
