class JsonParser::House
  include JsonParser
  include ::SafeAttributeAssignment
  attr_reader :json

  json_parse :age, :value, :floors

  def initialize(json)
    @json = json
  end
end
