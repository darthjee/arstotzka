# frozen_string_literal: true

module Arstotzka
  class KeyReader
    include Base

    # Creates a new instance of Reader
    #
    # @param [Hash] hash Hash where the key will be found
    # @param [String] key The key to be checked
    def initialize(hash, key)
      @hash = hash
      @key  = key
    end

    def read
      check_key!

      hash.key?(key) ? hash[key] : hash[key.to_sym]
    end

    private

    attr_reader :hash, :key

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
  end
end
