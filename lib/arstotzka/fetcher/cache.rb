# frozen_string_literal: true

module Arstotzka
  class Fetcher
    class Cache
      include Base

      def initialize(options_hash = {}, &block)
        self.options = options_hash
        @block = block
      end

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

      def fetch_with_cache
        if cached?
          fetch_from_cache
        else
          instance.instance_variable_set("@#{key}", block.call)
        end
      end

      def fetch_from_cache
        instance.instance_variable_get("@#{key}")
      end

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
