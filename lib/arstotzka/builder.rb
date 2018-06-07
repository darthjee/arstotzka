class Arstotzka::Builder < Sinclair

  attr_reader :attr_names, :path, :full_path, :cached

  def initialize(attr_names, clazz, path: nil, full_path: nil, cached: false, **options)
    super(clazz, {
      after:     false,
      case:      :lower_camel,
      class:     nil,
      compact:   false,
      default:   nil,
      flatten:   false,
      json:      :json,
      type:      :none
    }.merge(options.symbolize_keys))

    @attr_names = attr_names
    @path = path
    @full_path = full_path
    @cached = cached
    init
  end

  private

  def init
    attr_names.each do |attr|
      add_attr(attr)
    end
  end

  def real_path(attribute)
    full_path || [path, attribute].compact.join('.')
  end

  def json_name
    options[:json]
  end

  def wrapper_clazz
    options[:class]
  end

  def case_type
    options[:case]
  end

  def fetcher_options(attribute)
    options.slice(:compact, :after, :type, :flatten, :default).merge({
      clazz: wrapper_clazz,
      case_type: case_type,
      path: real_path(attribute)
    })
  end

  def add_attr(attribute)
    add_method attribute, "#{cached ? cached_fetcher(attribute) : attr_fetcher(attribute)}"
  end

  def attr_fetcher(attribute)
    <<-CODE
      ::Arstotzka::Fetcher.new(
        #{json_name}, self, #{fetcher_options(attribute)}
      ).fetch
    CODE
  end

  def cached_fetcher(attribute)
    <<-CODE
      @#{attribute} ||= #{attr_fetcher(attribute)}
    CODE
  end
end
