# frozen_string_literal: true

module Arstotzka
  # Reads a value from a hash using the path as list of keys
  class Reader
    # @param path [Array] path of keys broken down as array
    # @param case_type [Symbol] Case of the keys
    #   - lower_camel: keys in the hash are lowerCamelCase
    #   - upper_camel: keys in the hash are UpperCamelCase
    #   - snake: keys in the hash are snake_case
    def initialize(path:, case_type:)
      @case_type = case_type
      @path = path.map(&method(:change_case))
    end

    # Reads the value of one key in the hash
    #
    # @param hash [Hash] hash to be read
    # @param index [Integer] Index of the key (in path) to be used
    #
    # @return Object The value fetched from the hash
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
      key = path[index]

      check_key!(hash, key)

      hash.key?(key) ? hash[key] : hash[key.to_sym]
    end

    # Checks if index is within path range
    #
    # @example
    #   reader = Arstotzka::Reader.new(%w(person full_name), case_type: :snake)
    #   reader.read(hash, 1) # returns false
    #   reader.read(hash, 2) # returns true
    def ended?(index)
      index >= path.size
    end

    private

    attr_reader :path, :case_type

    def check_key!(hash, key)
      return if key?(hash, key)
      raise Exception::KeyNotFound
    end

    def key?(hash, key)
      hash&.key?(key) || hash&.key?(key.to_sym)
    end

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
