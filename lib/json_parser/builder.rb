class JsonParser::Builder < Sinclair

  attr_reader :attr_names

  def initialize(attr_names, clazz, options)
    super(clazz, {
      after:     false,
      cached:    false,
      case:      :lower_camel,
      class:     nil,
      compact:   false,
      default:   nil,
      flatten:   false,
      full_path: nil,
      json:      :json,
      path:      nil,
      type:      :none
    }.merge(options.symbolize_keys))

    @attr_names = attr_names
    init
  end

  private

  delegate :path, :full_path, :cached, :compact,
           :type, :after, to: :options_object

  def init
    attr_names.each do |attr|
      add_attr(attr)
    end
  end

  def json_name
    options[:json]
  end

  def real_path(attribute)
    full_path || [path, attribute].compact.join('.')
  end

  def wrapper_clazz
    options[:class]
  end

  def case_type
    options[:case]
  end

  def fetcher_options
    options.slice(:compact, :after, :type, :flatten, :default).merge({
      clazz: wrapper_clazz,
      case_type: case_type
    })
  end

  def add_attr(attribute)
    add_method attribute, "#{cached ? cached_fetcher(attribute) : attr_fetcher(attribute)}"
  end

  def attr_fetcher(attribute)
    <<-CODE
      ::JsonParser::Fetcher.new(
        #{json_name}, '#{real_path(attribute)}', self, #{fetcher_options}
      ).fetch
    CODE
  end

  def cached_fetcher(attribute)
    <<-CODE
      @#{attribute} ||= #{attr_fetcher(attribute)}
    CODE
  end
end
