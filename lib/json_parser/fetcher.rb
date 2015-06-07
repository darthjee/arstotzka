class JsonParser::Fetcher
  include OptionsParser

  attr_reader :path, :json

  delegate :after, :instance, to: :options_object
  delegate :wrap, to: :post_processor
  delegate :crawl, to: :crawler

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

  def crawler
    @crawler ||= buidl_crawler
  end

  def buidl_crawler
    JsonParser::Crawler.new(crawler_options) do |value|
      wrap(value)
    end
  end

  def crawler_options
    options.slice(:case_type, :compact)
  end

  def post_processor
    @post_processor ||= build_post_processor
  end

  def build_post_processor
    JsonParser::PostProcessor.new(post_processor_options)
  end

  def post_processor_options
    options.slice(:clazz, :type)
  end
end
