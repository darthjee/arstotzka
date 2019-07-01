# frozen_string_literal: true

module Arstotzka
  class Config < Sinclair::Config
    DEFAULT_OPTIONS = {
      after:      false,
      after_each: nil,
      cached:     false,
      case:       :lower_camel,
      compact:    false,
      default:    nil,
      flatten:    false,
      full_path:  nil,
      json:       :json,
      klass:      nil,
      path:       nil,
      type:       :none
    }.freeze

    add_configs DEFAULT_OPTIONS

    def options(options_hash = {})
      Options.new(
        to_hash.symbolize_keys.merge(
          options_hash.symbolize_keys
        )
      )
    end
  end
end
