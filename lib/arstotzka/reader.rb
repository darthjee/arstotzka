# frozen_string_literal: true

module Arstotzka
  # @api private
  #
  # Reads a value from a hash using the keys as list of keys
  class Reader
    include Base

    # Creates a new instance of Reader
    #
    # @overload initialize(options_hash={})
    #   @param options_hash [Hash] options of initialization
    #   @option options_hash keys [Array] keys of keys broken down as array
    #   @option options_hash case [Symbol] Case of the keys
    #     - lower_camel: keys in the hash are lowerCamelCase
    #     - upper_camel: keys in the hash are UpperCamelCase
    #     - snake: keys in the hash are snake_case
    # @overload initialize(options)
    #   @param options [Arstotzka::Options] options of initialization object
    #
    # @return [Arstotzka::Reader]
    def initialize(options_hash = {})
      self.options = options_hash
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
    #   reader = Arstotzka::Reader.new(full_path: 'person.full_name', case: :snake)
    #   reader.read(hash, 1) # returns 'John'
    #
    # @example
    #   reader = Arstotzka::Reader.new(full_path: 'person.age', case: :upper_camel)
    #   reader.read(hash, 1) # returns 23
    #
    # @example
    #   reader = Arstotzka::Reader.new(full_path: 'person.car_collection.model', case: :snake)
    #   reader.read(hash, 1) # raises {Arstotzka::Exception::KeyNotFound}
    #
    # @example
    #   reader = Arstotzka::Reader.new(full_path: 'person.car_collection.model', case: :lower_camel)
    #   reader.read(hash, 1) # returns [
    #                        #   { maker: 'Ford', 'model' => 'Model A' },
    #                        #   { maker: 'BMW', 'model' => 'Jetta' }
    #                        # ]
    def read(hash, index)
      key = keys[index]

      KeyReader.new(hash, key, options).read
    end

    # @private
    #
    # Checks if index is within keys range
    #
    # @example
    #   reader = Arstotzka::Reader.new(%w(person full_name), case: :snake)
    #   reader.read(hash, 1) # returns false
    #   reader.read(hash, 2) # returns true
    def ended?(index)
      index >= keys.size
    end

    private

    # @private
    attr_reader :options
    delegate :keys, to: :options
  end
end
