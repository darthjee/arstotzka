# frozen_string_literal: true

module Arstotzka
  # @api public
  #
  # Arstotzka configuration
  #
  # Configuration of Arstotzka is done through
  # +Arstotzka.configure+ which configures using
  # {Arstotzka::Config} by +Sinclar::Configurable+
  #
  # @see https://www.rubydoc.info/gems/sinclair/1.4.1/Sinclair/Config
  #   Sinclair::Config
  #
  # @example (see #options)
  class Config < Sinclair::Config
    # Default values for {ClassMethods#expose}
    DEFAULT_CONFIGS = {
      after:      false,
      after_each: nil,
      cached:     false,
      case:       :lower_camel,
      compact:    false,
      default:    nil,
      flatten:    false,
      json:       :json,
      klass:      nil,
      type:       :none
    }.freeze

    add_configs DEFAULT_CONFIGS

    # @api private
    #
    # Returns a new instance of {Options}
    #
    # the new instance will have it's values as a merge
    # from configuration and given options_hash
    #
    # @param options_hash [Hash] options override
    #
    # @return [Options]
    #
    # @example Generating options
    #   Arstotzka.configure do |config|
    #     config.case :snake
    #   end
    #
    #   config = Arstotzka.config
    #   options = config.options(klass: Person)
    #
    #   options.to_h
    #   # returns
    #   # {
    #   #   after:      false,
    #   #   after_each: nil,
    #   #   cached:     false,
    #   #   case:       :snake,
    #   #   compact:    false,
    #   #   default:    nil,
    #   #   flatten:    false,
    #   #   json:       :json,
    #   #   klass:      Person,
    #   #   type:       :none
    #   # }
    def options(options_hash = {})
      Options.new(
        to_hash.symbolize_keys.merge(
          options_hash.symbolize_keys
        )
      )
    end
  end
end
