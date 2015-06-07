class JsonParser::PostProcessor
  include OptionsParser
  include TypeCast

  attr_reader :options

  delegate :clazz, :type, to: :options_object

  def initialize(options = {})
    @options = options
  end

  def wrap(value)
    value = cast(value) unless value.is_a?(Array) || !type

    return value unless clazz || value.is_a?(Array)
    return clazz.new value unless value.is_a? Array
    value.map { |v| wrap v }
  end

  def cast(value)
    send("to_#{type}", value)
  end
end