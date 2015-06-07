class JsonParser::Crawler
  include OptionsParser

  attr_reader :post_process

  delegate :case_type, :compact, to: :options_object

  def initialize(options = {}, &block)
    @options = options
    @post_process = block
  end

  def crawl(json, path)
    return nil if json.nil?
    return wrap(json) if path.empty?
    return crawl_array(json, path) if json.is_a? Array

    key = change_case(path[0])
    value = json.key?(key) ? json[key] : json[key.to_sym]
    crawl(value, path[1,path.size])
  end

  private

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

  def crawl_array(array, path)
    array.map { |j| crawl(j, path) }.tap do |a|
      a.compact! if compact
    end
  end
end
