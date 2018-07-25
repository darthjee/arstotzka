# frozen_string_literal: true

class Collector
  class Game
    include Arstotzka

    attr_reader :json

    expose :name
    expose :played, type: :float

    def initialize(json)
      @json = json
    end

    def ==(other)
      return false if other.class != self.class
      name == other.name && played == other.played
    end

    def finished?
      played > 85.0
    end
  end
end
