# frozen_string_literal: true

module Arstotzka
  # @api private
  #
  # Class responsible for reading values from a hash
  class KeyReader
    include Base

    # Creates a new instance of Reader
    #
    # @param [Hash] hash Hash where the key will be found
    # @param [String] base_key The key to be checked
    #   (before case change)
    def initialize(hash, base_key, options_hash = {})
      self.options = options_hash

      @hash     = hash
      @base_key = base_key
    end

    # Reads value from hash key
    #
    # @raise Arstotzka::Exception::KeyNotFound
    #
    # @return [Object]
    #
    # @example Simple usage
    #   hash = { theKey: 'value' }
    #   key  = { 'the_key' }
    #   reader = Arstotzka::KeyReader.new(hash, key)
    #
    #   reader.read # returns 'value'
    #
    # @example
    #   hash = { 'the_key' => 'value' }
    #   key  = 'TheKey'
    #   reader = Arstotzka::KeyReader.new(hash, key)
    #
    #   reader.read # returns 'value'
    #
    def read
      raise Exception::KeyNotFound unless key?

      hash.key?(key) ? hash[key] : hash[key.to_sym]
    end

    private

    attr_reader :hash, :base_key, :options
    delegate :key, to: :key_changer

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
      return unless hash
      hash.key?(key) || hash.key?(key.to_sym)
    end

    # @private
    #
    # Returns key changer for getting the correct key
    #
    # @return [KeyChanger]
    def key_changer
      @key_changer ||= KeyChanger.new(base_key, options)
    end
  end
end
