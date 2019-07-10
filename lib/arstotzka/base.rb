# frozen_string_literal: true

module Arstotzka
  # @api private
  #
  # Common code to be used by classes
  module Base
    # @overload iniitalize(options_hash = {})
    #   @param options_hash [Hash] global options shared
    #   among all {Arstotzka}::Objects
    #
    # @overload iniitalize(options)
    #   @param options [Arstotzka::Options] global options
    #   shared among all {Arstotzka}::Objects
    def initialize(options)
      self.options = options
    end

    private

    # Sets the @options object
    #
    # @overload options=(options_hash={})
    #   @param options_hash [Hash] options
    #
    # @overload options=(options)
    #   @param options [Arstotzka::Options] options object
    #
    # @return [Arstotzka::Options]
    def options=(options)
      @options = if options.is_a?(Hash)
                   Arstotzka.config.options(options)
                 else
                   options
                 end
    end
  end
end
