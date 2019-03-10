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
      options = correct_keys(options.dup)

      options = DEFAULT_OPTIONS.merge(options)

      super(options)
    end

    def case_type
      self.case
    end

    def merge(options)
      self.class.new(to_h.merge(options))
    end

    private

    def correct_keys(options)
      klass = options.delete(:class)
      warn ":class has been deprecated, prefer 'expose class: #{klass}'" if klass
      options[:klass] ||= klass

      case_type = options.delete(:case_type)
      options[:case] = case_type if case_type

      options
    end
  end
end
