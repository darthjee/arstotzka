# frozen_string_literal: true

module Arstotzka
  class KeyChanger
    include Base

    def initialize(base_key, options_hash = {})
      self.options = options_hash
      @base_key = base_key
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
