class JsonParser::Fetcher
  include OptionsParser

  attr_reader :path, :json, :options

  delegate :after, :instance, :compact, :case_type, to: :options_object
  delegate :wrap, to: :post_processor

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

  def post_processor
    @post_processor ||= build_post_processor
  end

  def build_post_processor
    JsonParser::PostProcessor.new(options.slice(:clazz, :type))
  end

  def crawl(json, path)
    return nil if json.nil?
    return wrap(json) if path.empty?
    return crawl_array(json, path) if json.is_a? Array

    key = change_case(path[0])
    value = json.key?(key) ? json[key] : json[key.to_sym]
    crawl(value, path[1,path.size])
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

  def crawl_array(array, path)
    array.map { |j| crawl(j, path) }.tap do |a|
      a.compact! if compact
    end
  end
end