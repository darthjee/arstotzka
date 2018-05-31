class StarGazer
  include JsonParser

  json_parse :favorite_star, full_path: 'universe.star',
             default: { name: 'Sun' }, class: ::Star

  attr_reader :json

  def initialize(json = {})
    @json = json
  end
end

