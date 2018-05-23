class JsonParser::Builder < Sinclair

  attr_reader :attr_names
  delegate :path, :cached, :compact, :type, :after, to: :options_object

  def initialize(attr_names, clazz, options)
    @attr_names = attr_names
    super(clazz, options)
    init
  end

  private

  def init
    attr_names.each do |attr|
      add_attr(attr)
    end
  end

  def json_name
    options[:json]
  end

  def full_path(attribute)
    options[:full_path] || [path, attribute].compact.join('.')
  end

  def wrapper_clazz
    options[:class]
  end

  def case_type
    options[:case]
  end

  def fetcher_options
    options.slice(:compact, :after, :type, :flatten).merge({
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
        #{json_name}, '#{full_path(attribute)}', self, #{fetcher_options}
      ).fetch
    CODE
  end

  def cached_fetcher(attribute)
    <<-CODE
      @#{attribute} ||= #{attr_fetcher(attribute)}
    CODE
  end
end
