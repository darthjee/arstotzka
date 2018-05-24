class JsonParser::Game
  include JsonParser
  include SafeAttributeAssignment
  attr_reader :json

  json_parse :name, :publisher

  def initialize(json)
    @json = json
  end
end
