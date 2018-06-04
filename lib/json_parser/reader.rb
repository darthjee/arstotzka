module JsonParser
  class Reader
    attr_reader :path, :case_type

    def initialize(path:, case_type:)
      @case_type = case_type
      @path = path.map { |p| change_case(p) }
    end

    def fetch(json, index)
      key = path[index]

      raise Exception::KeyNotFound unless json&.key?(key) || json&.key?(key.to_sym)

      json.key?(key) ? json[key] : json[key.to_sym]
    end

    def is_ended?(index)
      index >= path.size
    end

    private

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
