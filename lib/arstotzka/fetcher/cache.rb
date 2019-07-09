# frozen_string_literal: true

module Arstotzka
  class Fetcher
    # @api private
    #
    # Class responsible for reading instance variables
    # when cached option is given.
    #
    # When the "cache" is not accepted, block will be called
    # to determinate the value to be returned also caching
    # it in an instance variable
    class Cache
      include Base

      # @param block [Proc] block to be executed in case
      #   variable is not cached
      #
      # @overload initialize(options, &block)
      #   @param options [Arstotzka::Options] options passed
      #   as options object
      #
      # @overload initialize(options_hash, &block)
      #   @param options_hash [Hash] opttions passed as hash
      def initialize(options_hash = {}, &block)
        self.options = options_hash
        @block = block
      end

      # Fetches value from instance or block
      #
      # When cached option is given, fetches value
      # from cache, and in case of failure, retrieves
      # value from block given in the initialization
      #
      # @yield runs the block given in the initialization
      #   when the value was not found in the cache
      #
      # @return [Object]
      #
      # @example Without cache option
      #   settings = { min: 1, max: 100 }
      #   instance = Object.new
      #
      #   options = Arstotzka::Options.new(
      #     key: :x, instance: instance
      #   )
      #
      #   cache = Arstotzka::Fetcher::Cache.new do
      #     (settings[:min]..settings[:max]).sum
      #   end
      #
      #   cache.fetch # returns 5050
      #   settings[:max] = 10
      #   cache.fetch # returns 555
      #
      # @example With simple cache option
      #   settings = { calculate: false, min: 1, max: 100 }
      #   instance = Object.new
      #
      #   options = Arstotzka::Options.new(
      #     key: :x, instance: instance, cached: true
      #   )
      #
      #   cache = Arstotzka::Fetcher::Cache.new do
      #     if settings[:calculate]
      #       (settings[:min]..settings[:max]).sum
      #     end
      #   end
      #
      #   cache.fetch # returns nil (which is not considered cache)
      #   settings[:calculate] = true
      #   cache.fetch # returns 5050
      #   settings[:max] = 10
      #   cache.fetch # returns 5050 from cache
      #
      # @example With full cache option
      #   settings = { calculate: false, min: 1, max: 100 }
      #   instance = Object.new
      #
      #   options = Arstotzka::Options.new(
      #     key: :x, instance: instance, cached: :full
      #   )
      #
      #   cache = Arstotzka::Fetcher::Cache.new do
      #     if settings[:calculate]
      #       (settings[:min]..settings[:max]).sum
      #     end
      #   end
      #
      #   cache.fetch # returns nil
      #   settings[:calculate] = true
      #   cache.fetch # returns nil from cache
      def fetch
        if cached
          fetch_with_cache
        else
          block.call
        end
      end

      private

      attr_reader :block, :options
      delegate :cached, :key, :instance, to: :options

      # @private
      #
      # Checks and retrieve value from cache
      #
      # when the value is not found in cache,
      # block is called and it's value is cached
      # and returned
      #
      # @return [Object]
      def fetch_with_cache
        if cached?
          fetch_from_cache
        else
          instance.instance_variable_set("@#{key}", block.call)
        end
      end

      # @private
      #
      # Returns the value from the instance variable (cache)
      #
      # the instance variable name is the same name of
      # options.key (which is the same name of the method
      # created in the instance by {MethodBuilder}
      #
      # @return [Object]
      def fetch_from_cache
        instance.instance_variable_get("@#{key}")
      end

      # @private
      #
      # Checks if value is present on cache
      #
      # The presence depends on the type of the cache
      # - +true+ : nil values are considered not cached
      # - +:full+ : nil instance variables are considered cached
      #   values
      def cached?
        if cached == :full
          instance.instance_variable_defined?("@#{key}")
        else
          instance.instance_variable_get("@#{key}")
        end
      end
    end
  end
end
