class JsonParser::Fetcher
  include OptionsParser

  attr_reader :path, :json, :instance

  delegate :after, :flatten, to: :options_object
  delegate :wrap, to: :wrapper
  delegate :crawl, to: :crawler

  def initialize(json, path, instance, options = {})
    @path = path.to_s.split('.')
    @json = json
    @instance = instance
    @options = options
  end

  def fetch
    value = crawl(json)
    value.flatten! if flatten && value.respond_to?(:flatten!)
    value = instance.send(after, value) if after
    value
  end

  private

  def crawler
    @crawler ||= buidl_crawler
  end

  def buidl_crawler
    JsonParser::Crawler.new(path, crawler_options) do |value|
      wrap(value)
    end
  end

  def crawler_options
    options.slice(:case_type, :compact)
  end

  def wrapper
    @wrapper ||= build_wrapper
  end

  def build_wrapper
    JsonParser::Wrapper.new(wrapper_options)
  end

  def wrapper_options
    options.slice(:clazz, :type)
  end
end
