class JsonParser::PostProcessor
  include OptionsParser
  include TypeCast

  attr_reader :options

  delegate :clazz, :type, to: :options_object

  def initialize(options = {})
    @options = options
  end

  def wrap(value)
    return value.map { |v| wrap v } if value.is_a?(Array)

    value = cast(value) if type
    value = clazz.new(value) if clazz
    value
  end

  def cast(value)
    send("to_#{type}", value)
  end
end
