# frozen_string_literal: true

class Collector
  include Arstotzka

  MALE = 'male'
  FEMALE = 'female'

  attr_reader :hash

  expose :full_name, :age, path: :person, json: :hash
  expose :gender, path: :person, type: :gender, cached: true, json: :hash
  expose :car_names, flatten: true, compact: false, json: :hash,
                     default: 'MissingName',
                     full_path: 'collections.cars.units.nick_name'
  expose :finished_games, json: :hash,
                          flatten: true, class: Collector::Game,
                          after: :filter_finished, compact: true,
                          full_path: 'collections.games.titles'

  def initialize(hash = {})
    @hash = hash
  end

  private

  def filter_finished(games)
    games.select(&:finished?)
  end
end

module Arstotzka
  module TypeCast
    def to_gender(value)
      case value
      when 'man'
        Collector::MALE
      when 'woman'
        Collector::FEMALE
      else
        raise 'invalid gender'
      end
    end
  end
end
