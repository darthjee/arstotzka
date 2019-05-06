# frozen_string_literal: true

module Arstotzka
  # @api private
  #
  # Arstotzka exceptions
  module Exception
    # Exception raised when a key in the hash is not found
    class KeyNotFound < StandardError; end

    # Exception raised when configuration for FetcherBuilder is not found
    class FetcherBuilderNotFound < StandardError
      # Returns a new instance of FetcherBuilderNotFound
      #
      # @param attribute [Symbol] attribute's name
      # @param klass [Class] Class where the fetcher was being accessed
      #
      # @return [FetcherBuilderNotFound]
      def initialize(attribute, klass)
        @attribute = attribute
        @klass = klass
      end

      # Returns message specifying which attemp created the failure
      #
      # @return [String]
      def message
        "FetcherBuild not found for #{attribute} on #{klass}"
      end

      private

      attr_reader :attribute, :klass
    end
  end
end
