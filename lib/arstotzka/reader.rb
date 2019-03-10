# frozen_string_literal: true

module Arstotzka
  # @api private
  #
  # Reads a value from a hash using the keys as list of keys
  class Reader
    # Creates a new instance of Reader
    #
    # @param keys [Array] keys of keys broken down as array
    # @param case_type [Symbol] Case of the keys
    #   - lower_camel: keys in the hash are lowerCamelCase
    #   - upper_camel: keys in the hash are UpperCamelCase
    #   - snake: keys in the hash are snake_case
    #
    # @return [Aristotzka::Reader]
    def initialize(options = nil, **options_hash)
      options ||= Arstotzka::Options.new(options_hash)

      @options = options
      @keys = options.keys.map(&method(:change_case))
    end

    # Reads the value of one key in the hash
    #
    # @param hash [Hash] hash to be read
    # @param index [Integer] Index of the key (in keys) to be used
    #
    # @return [Object] The value fetched from the hash
    #
    # @example
    #   hash = {
    #     full_name: 'John',
    #     'Age' => 23,
    #     'carCollection' => [
    #       { maker: 'Ford', 'model' => 'Model A' },
    #       { maker: 'BMW', 'model' => 'Jetta' }
    #     ]
    #   }
    #
    #   reader = Arstotzka::Reader.new(%w(person full_name), case_type: :snake)
    #   reader.read(hash, 1) # returns 'John'
    #
    # @example
    #   reader = Arstotzka::Reader.new(%w(person age), case_type: :upper_camel)
    #   reader.read(hash, 1) # returns 23
    #
    # @example
    #   reader = Arstotzka::Reader.new(%w(person car_collection model), case_type: :snake)
    #   reader.read(hash, 1) # raises {Arstotzka::Exception::KeyNotFound}
    #
    # @example
    #   reader = Arstotzka::Reader.new(%w(person car_collection model), case_type: :lower_camel)
    #   reader.read(hash, 1) # returns [
    #                        #   { maker: 'Ford', 'model' => 'Model A' },
    #                        #   { maker: 'BMW', 'model' => 'Jetta' }
    #                        # ]
    def read(hash, index)
      key = keys[index]

      check_key!(hash, key)

      hash.key?(key) ? hash[key] : hash[key.to_sym]
    end

    # @private
    #
    # Checks if index is within keys range
    #
    # @example
    #   reader = Arstotzka::Reader.new(%w(person full_name), case_type: :snake)
    #   reader.read(hash, 1) # returns false
    #   reader.read(hash, 2) # returns true
    def ended?(index)
      index >= keys.size
    end

    private

    # @private
    attr_reader :keys, :options
    delegate :case_type, to: :options

    # @private
    #
    # Checks if a hash contains or not the key
    #
    # if the key is not found, an execption is raised
    #
    # @raise Arstotzka::Exception::KeyNotFound
    #
    # @return [NilClass]
    #
    # @see #key?
    def check_key!(hash, key)
      return if key?(hash, key)
      raise Exception::KeyNotFound
    end

    # @private
    #
    # Checks if a hash contains or not the key
    #
    # The check first happens using String key and,
    # in case of not found, searches as symbol
    #
    # @param [Hash] hash Hash where the key will be found
    # @param [String] key The key to be checked
    #
    # @return [Boolean]
    #
    # @see #check_key!
    def key?(hash, key)
      hash&.key?(key) || hash&.key?(key.to_sym)
    end

    # @private
    #
    # Transforms the key to have the correct case
    #
    # the possible case_types (instance attribute) are
    # - lower_camel: for cammel case with first letter lowercase
    # - upper_camel: for cammel case with first letter uppercase
    # - snake: for snake case
    #
    # @param [String] key the key to be transformed
    def change_case(key)
      case case_type
      when :lower_camel
        key.camelize(:lower)
      when :upper_camel
        key.camelize(:upper)
      when :snake
        key.underscore
      end
    end
  end
end
