# frozen_string_literal: true

module Arstotzka
  class Options < ::OpenStruct
    DEFAULT_OPTIONS = {
      json:      :json,
      path:      nil,
      full_path: nil,
      cached:    false,
      after:     false,
      case:      :lower_camel,
      class:     nil,
      compact:   false,
      default:   nil,
      flatten:   false,
      type:      :none
    }.freeze

    def initialize(options)
      super(DEFAULT_OPTIONS.merge(options))
    end
  end
end
