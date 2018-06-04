class Arstotzka::Fetcher
  include Sinclair::OptionsParser

  attr_reader :path, :json, :instance

  delegate :after, :flatten, to: :options_object
  delegate :wrap, to: :wrapper

  def initialize(json, instance, path:, **options)
    @path = path.to_s.split('.')
    @json = json
    @instance = instance
    @options = options
  end

  def fetch
    value = crawler.value(json)
    value.flatten! if flatten && value.respond_to?(:flatten!)
    value = instance.send(after, value) if after
    value
  end

  private

  def crawler
    @crawler ||= buidl_crawler
  end

  def buidl_crawler
    Arstotzka::Crawler.new(crawler_options) do |value|
      wrap(value)
    end
  end

  def crawler_options
    options.slice(:case_type, :compact, :default).merge(path: path)
  end

  def wrapper
    @wrapper ||= build_wrapper
  end

  def build_wrapper
    Arstotzka::Wrapper.new(wrapper_options)
  end

  def wrapper_options
    options.slice(:clazz, :type)
  end
end
