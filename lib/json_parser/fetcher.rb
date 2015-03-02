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