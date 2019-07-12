# frozen_string_literal: true

module Arstotzka
  # @api private
  #
  # Class reponsible for processing the result of {Crawler#crawl}.
  #
  # PostProcessor proccess the whole collection and not
  # individual results
  class PostProcessor
    include Base

    # @overload initialize(options_hash)
    #   @param options_hash [Hash] options passed by
    #     {ClassMethods#expose}
    #   @option options_hash instance [Objct]
    #   @option options_hash after [String,Symbol] instance method to be called on the
    #     returning value returned by {Crawler} before being returned by {Fetcher}.
    #   @option options_hash flatten [Boolean] flag signallying if multi levels
    #     arrays should be flattened to one level array (applying +Array#flatten+)
    # @overload initialize(options)
    #   @param options [Hash] options passed by
    #     {ClassMethods#expose}
    def initialize(options_hash = {})
      self.options = options_hash
    end

    # Apply transformation and filters on the result
    #
    # @param value [Object] value is returned from crawler
    #   being a single object, or an array.
    #
    # @return [Object]
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
