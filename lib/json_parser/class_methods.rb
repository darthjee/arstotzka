module JsonParser::ClassMethods

  def json_parse(*attr_names)
    options = {
      path: nil,
      json: :json,
      full_path: nil,
      cached: false,
      class: nil,
      compact: false,
      after: nil,
      case: :lower_camel,
      type: :none
    }.merge(attr_names.extract_options!)

    builder = Builder.new(attr_names, self, options)
    builder.build
  end

  class Builder
    include OptionsParser

    attr_reader :attr_names, :methods_def

    delegate :path, :cached, :compact, :type, to: :options_object

    def initialize(attr_names, instance, options)
      @attr_names = attr_names
      @instance = instance
      @options = options
      @methods_def = []
      init
    end

    def build
      methods_def.each do |method_def|
        @instance.module_eval(method_def, __FILE__, __LINE__ + 1)
      end
    end

    private

    def init
      attr_names.each do |attr|
        add_attr(attr)
      end
    end

    def json_name
      options[:json]
    end

    def full_path(attribute)
      options[:full_path] || [path, attribute].compact.join('.')
    end

    def clazz
      options[:class]
    end

    def after
      options[:after] ? ":#{options[:after]}" : false
    end

    def case_type
      options[:case]
    end

    def add_attr(attribute)
      @methods_def << <<-CODE
        def #{attribute}
          #{cached ? cached_fetcher(attribute) : attr_fetcher(attribute)}
        end
      CODE
    end

    def attr_fetcher(attribute)
      <<-CODE
        JsonParser::Fetcher.new(
          #{json_name}, '#{full_path(attribute)}', {
            instance: self,
            clazz: #{clazz || 'nil'},
            compact: #{compact || 'false'},
            after: #{after},
            case_type: :#{case_type},
            type: :#{type}
          }
        ).fetch
      CODE
    end

    def cached_fetcher(attribute)
      <<-CODE
        @#{attribute} ||= #{attr_fetcher(attribute)}
      CODE
    end
  end
end
