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
  # @example Redefining json method and case type
  #   class Office
  #     include Arstotzka
  #
  #     expose :employes, full_path: 'employes.first_name',
  #                       compact: true
  #
  #     def initialize(hash)
  #       @hash = hash
  #     end
  #   end
  #
  #   hash = {
  #     employes: [{
  #       first_name: 'Rob'
  #     }, {
  #       first_name: 'Klara'
  #     }]
  #   }
  #
  #   office = Office.new(hash)
  #
  #   office.employes # raises NoMethodError as json is not a method
  #
  #   Arstotzka.configure { json :@hash }
  #
  #   office.employes # returns []
  #
  #   Arstotzka.configure { |c| c.case :snake }
  #
  #   office.employes # returns %w[Rob Klara]
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
      type:       :none,
      before:     nil
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
    #   #   type:       :none,
    #   #   full_path:  nil,
    #   #   key:        nil,
    #   #   instance:   nil,
    #   #   befor:      nil
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
