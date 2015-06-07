class JsonParser::PostProcessor
  attr_reader :options

  delegate :clazz, to: :options_object

  def initialize(options = {})
    @options = options
  end

  def wrap(json)
    return json unless clazz
    return clazz.new json unless json.is_a? Array
    json.map { |v| wrap v }
  end

  private

  def options_object
    @options_object ||= OpenStruct.new options
  end
end