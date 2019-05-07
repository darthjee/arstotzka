# frozen_string_literal: true

module Arstotzka
  class KeyReader
    include Base

    # Creates a new instance of Reader
    #
    # @param [Hash] hash Hash where the key will be found
    # @param [String] base_key The key to be checked (before case change)
    def initialize(hash, base_key, options_hash = {})
      self.options = options_hash

      @hash     = hash
      @base_key = base_key
    end

    def read
      check_key!

      hash.key?(key) ? hash[key] : hash[key.to_sym]
    end

    private

    attr_reader :hash, :base_key, :options

    # @private
    #
    # Checks if hash contains or not the key
    #
    # if the key is not found, an execption is raised
    #
    # @raise Arstotzka::Exception::KeyNotFound
    #
    # @return [NilClass]
    #
    # @see #key?
    def check_key!
      return if key?

      raise Exception::KeyNotFound
    end

    # @private
    #
    # Checks if hash contains or not the key
    #
    # The check first happens using String key and,
    # in case of not found, searches as symbol
    #
    # @return [Boolean]
    #
    # @see #check_key!
    def key?
      hash&.key?(key) || hash&.key?(key.to_sym)
    end

    # @private
    #
    # Transforms the key to have the correct case
    #
    # the possible cases (instance attribute) are
    # - lower_camel: for cammel case with first letter lowercase
    # - upper_camel: for cammel case with first letter uppercase
    # - snake: for snake case
    #
    # @param [String] key the key to be transformed
    #
    # @return [String] the string transformed
    def key
      @key ||= case options.case
               when :lower_camel
                 base_key.camelize(:lower)
               when :upper_camel
                 base_key.camelize(:upper)
               when :snake
                 base_key.underscore
               end
    end
  end
end
