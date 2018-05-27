class JsonParser::Crawler
  attr_reader :post_process, :path, :case_type, :compact

  def initialize(path, case_type: :lower_camel, compact: :false, &block)
    @case_type = case_type
    @compact = compact
    @path = path.map { |p| change_case(p) }
    @post_process = block
  end

  def crawl(json, index = 0)
    return nil if json.nil?
    return wrap(json) if is_ended?(index)
    return crawl_array(json, index) if json.is_a? Array

    crawl(fetch(json, index), index + 1)
  end

  private

  def fetch(json, index)
    key = path[index]
    json.key?(key) ? json[key] : json[key.to_sym]
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
