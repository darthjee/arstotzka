# frozen_string_literal: true

module Arstotzka
  class Reader
    attr_reader :path, :case_type

    def initialize(path:, case_type:)
      @case_type = case_type
      @path = path.map(&method(:change_case))
    end

    def read(json, index)
      key = path[index]

      check_key!(json, key)

      json.key?(key) ? json[key] : json[key.to_sym]
    end

    def ended?(index)
      index >= path.size
    end

    private

    def check_key!(json, key)
      return if key?(json, key)
      raise Exception::KeyNotFound
    end

    def key?(json, key)
      json&.key?(key) || json&.key?(key.to_sym)
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
