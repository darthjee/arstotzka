class JsonParser::PostProcessor
  include OptionsParser
  include TypeCast

  attr_reader :options

  delegate :clazz, :type, to: :options_object

  def initialize(options = {})
    @options = options
  end

  def wrap(json)
    json = cast(json) unless json.is_a?(Array) || !type

    return json unless clazz || json.is_a?(Array)
    return clazz.new json unless json.is_a? Array
    json.map { |v| wrap v }
  end

  def cast(value)
    send("to_#{type}", value)
  end
end