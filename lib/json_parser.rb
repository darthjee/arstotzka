module JsonParser
  extend ActiveSupport::Concern

  module ClassMethods
    def json_parse(*attr_names)
      options = {
        path: nil,
        json: :json,
        full_path: nil,
        cached: false,
        class: nil,
        compact: false,
        after: nil
      }.merge(attr_names.extract_options!)

      builder = Builder.new(attr_names, self, options)
      builder.build
    end

    class Builder
      attr_reader :attr_names, :options, :methods_def

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

      def path
        options[:path]
      end

      def json_name
        options[:json]
      end

      def full_path(attribute)
        options[:full_path] || [path, attribute].compact.join('.')
      end

      def cached
        options[:cached]
      end

      def clazz
        options[:class]
      end

      def compact
        options[:compact]
      end

      def after
        options[:after] ? ":#{options[:after]}" : false
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
              class: #{clazz || 'nil'},
              compact: #{compact || 'false'},
              after: #{after}
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

  class Fetcher
    attr_reader :path, :json, :options

    def initialize(json, path, options = {})
      @path = path.to_s.split('.')
      @json = json
      @options = options
    end

    def fetch
      value = crawl(json, path)
      value = instance.send(after, value) if after
      value
    end

    private

    def crawl(json, path)
      return nil if json.nil?
      return wrap(json) if path.empty?
      return crawl_array(json, path) if json.is_a? Array

      key = path[0].camelize(:lower)
      crawl(json[key], path[1,path.size])
    end

    def crawl_array(array, path)
      array.map { |j| crawl(j, path) }.tap do |a|
        a.compact! if compact
      end
    end

    def wrap(json)
      return json unless clazz
      return clazz.new json unless json.is_a? Array
      json.map { |v| wrap v }.tap do |j|
        j.compact! if compact
      end
    end

    def clazz
      options[:class]
    end

    def after
      options[:after]
    end

    def instance
      options[:instance]
    end

    def compact
      options[:compact]
    end
  end
end
