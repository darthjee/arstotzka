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
      klass:     nil,
      compact:   false,
      default:   nil,
      flatten:   false,
      type:      :none
    }.freeze

    def initialize(options)
      merged = DEFAULT_OPTIONS.merge(options)
      klass = merged.delete(:class)
      merged[:klass] ||= klass
      warn ":class has been deprecated, prefer 'expose class: #{klass}'" if klass

      super(merged)
    end
  end
end
