# frozen_string_literal: true

module Arstotzka
  module Exception
    # Exception raised when a key in the hash is not found
    class KeyNotFound < StandardError; end

    class FetcherBuilderNotFound < StandardError
      def initialize(attribute, klass)
        @attribute = attribute
        @klass = klass
      end

      def message
        "FetcherBuild not found for #{attribute} on #{klass}"
      end

      private

      attr_reader :attribute, :klass
    end
  end
end
