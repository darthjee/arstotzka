# frozen_string_literal: true

class StarGazer
  include Arstotzka

  expose :favorite_star, full_path: 'universe.star',
                         default: { name: 'Sun' }, klass: ::Star

  attr_reader :json

  def initialize(json = {})
    @json = json
  end
end
