class JsonParser::Wrapper
  include Sinclair::OptionsParser
  include JsonParser::TypeCast

  delegate :clazz, :type, to: :options_object

  def initialize(options = {})
    @options = options
  end

  def wrap(value)
    return value.map { |v| wrap v } if value.is_a?(Array)

    value = cast(value) if has_type? && !value.nil?
    return if value.nil?

    value = clazz.new(value) if clazz
    value
  end

  private

  def has_type?
    type.present? && type != :none
  end

  def cast(value)
    send("to_#{type}", value)
  end
end
