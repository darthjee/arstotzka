# frozen_string_literal: true

module Arstotzka
  # @api private
  #
  # Class responsible for changing a key
  class KeyChanger
    include Base

    # @param [String] base_key The key to be checked
    #   (before case change)
    #
    # @overload initialize(base_key, options_hash)
    #   @param options_hash [Hash] options passed on expose
    #   @option options_hash case [Symbol] case type for key
    #     transformation
    #     - +:snake+ : snake_cased keys
    #     - +:lower_camel+ : lowerCamelCased keys
    #     - +:upper_camel+ : UperCamelCased keys
    # @overload initialize(base_key, options)
    #   @param options [Option] options passed on expose
    def initialize(base_key, options_hash = {})
      self.options = options_hash
      @base_key = base_key
    end

    # Transforms the key to have the correct case
    #
    # the possible cases (instance attribute) are
    # - lower_camel: for cammel case with first letter lowercase
    # - upper_camel: for cammel case with first letter uppercase
    # - snake: for snake case
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

    private

    attr_reader :base_key, :options
  end
end
