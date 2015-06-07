class JsonParser::Crawler
  include OptionsParser

  attr_reader :post_process, :path

  delegate :case_type, :compact, to: :options_object

  def initialize(path, options = {}, &block)
    @path = path
    @options = options
    @post_process = block
  end

  def crawl(json, index = 0)
    return nil if json.nil?
    return wrap(json) if is_ended?(index)
    return crawl_array(json, index) if json.is_a? Array

    key = change_case(path[index])
    value = json.key?(key) ? json[key] : json[key.to_sym]
    crawl(value, index + 1)
  end

  def is_ended?(index)
    index >= path.size
  end

  def wrap(json)
    post_process.call(json)
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

  def crawl_array(array, index)
    array.map { |j| crawl(j, index) }.tap do |a|
      a.compact! if compact
    end
  end
end
