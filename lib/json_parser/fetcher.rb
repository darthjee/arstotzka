class JsonParser::Fetcher
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

  def case_type
    options[:case_type]
  end
end