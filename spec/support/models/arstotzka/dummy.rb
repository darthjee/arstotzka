class Arstotzka::Dummy
  include Arstotzka
  attr_reader :json

  expose :id
  expose :name, path: 'user'
  expose :father_name, full_path: 'father.name'
  expose :age, cached: true
  expose :house, class: ::House
  expose :old_house, class: ::House, cached: true
  expose :games, class: ::Game
  expose :games_filtered, class: ::Game, after: :filter_games, full_path: 'games'

  def initialize(json)
    @json = json
  end

  def filter_games(games)
    games.select do |g|
      g.publisher != 'sega'
    end
  end
end
