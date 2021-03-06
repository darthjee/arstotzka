# frozen_string_literal: true

require 'active_support'
require 'active_support/all'
require 'sinclair'

# Concern that enables the translation of domain though the
# usage of the class method  +expose+
#
# @example
#   json = <<-JSON
#     {
#       "person": {
#         "fullName": "Kelly Khan",
#         "age": 32,
#         "gender": "woman"
#       },
#       "collections": {
#         "cars": [{
#           "maker": "Volkswagen",
#           "model": "Jetta",
#           "units": [{
#             "nickName": "Betty",
#             "year": 2013
#           }, {
#             "nickName": "Roger",
#             "year": 2014
#           }]
#         }, {
#           "maker": "Ferrari",
#           "model": "Ferrari X1",
#           "units": [{
#             "nickName": "Geronimo",
#             "year": 2014
#           }]
#         }, {
#           "maker": "Fiat",
#           "model": "Uno",
#           "units": [{
#             "year": 1998
#           }]
#         }],
#         "games":[{
#           "producer": "Lucas Pope",
#           "titles": [{
#             "name": "papers, please",
#             "played": "10.2%"
#           }, {
#             "name": "TheNextBigThing",
#             "played": "100%"
#           }]
#         }, {
#           "producer": "Nintendo",
#           "titles": [{
#             "name": "Zelda",
#             "played": "90%"
#           }]
#         }, {
#           "producer": "BadCompany"
#         }]
#       }
#     }
#   JSON
#
#   hash = JSON.parse(json)
#
# @example
#   class Collector
#     include Arstotzka
#
#     MALE  = 'male'
#     FEMALE= 'female'
#
#     attr_reader :hash
#
#     expose :full_name, :age, path: :person, json: :hash
#     expose :gender, path: :person, type: :gender, cached: true, json: :hash
#
#     def initialize(hash = {})
#       @hash = hash
#     end
#   end
#
#   module Arstotzka
#     module TypeCast
#       def to_gender(value)
#         case value
#         when 'man'
#           Collector::MALE
#         when 'woman'
#           Collector::FEMALE
#         else
#           raise 'invalid gender'
#         end
#       end
#     end
#   end
#
#   collector = Collector.new(hash)
#   collector.full_name # returns 'Kelly Khan'
#   collector.age       # returns 32
#   collector.gender    # returns Collector::FEMALE
#
#   hash['person']['fullName'] = 'Robert'
#   collector.full_name # returns 'Robert'
#
#   hash['person']['gender'] = 'man'
#   collector.gender    # returns Collector::FEMALE as it was cached
#
# @example
#   class Collector
#     expose :car_names, flatten: true, compact: false, json: :hash,
#            default: 'MissingName',
#            full_path: 'collections.cars.units.nick_name'
#   end
#
#   collector = Collector.new(hash)
#   collector.car_names # returns [
#                       #   'Betty', 'Roger',
#                       #   'Geronimo', 'MissingName'
#                       # ]
#
# @example
#   class Collector
#     class Game
#       include Arstotzka
#
#       attr_reader :json
#
#       expose :name
#       expose :played, type: :float
#
#       def initialize(json)
#         @json = json
#       end
#
#       def finished?
#         played > 85.0
#       end
#     end
#   end
#
#   class Collector
#     expose :finished_games, json: :hash,
#            flatten: true, klass: Collector::Game,
#            after: :filter_finished, compact: true,
#            full_path: 'collections.games.titles'
#
#     private
#
#     def filter_finished(games)
#       games.select(&:finished?)
#     end
#   end
#
#   collector = Collector.new(hash)
#   collector.finished_games # returns [
#                            #   Collector::Game.new(name: "TheNextBigThing", played: 100.0),
#                            #   Collector::Game.new(name: "Zelda", played: 90.0)
#                            # ]
#
# @example (see Arstotzka::Options)
#
# @see Arstotzka::MethodBuilder
# @see Arstotzka::ClassMethods
module Arstotzka
  require 'arstotzka/config'

  extend ActiveSupport::Concern
  extend Sinclair::Configurable

  autoload :Base,           'arstotzka/base'
  autoload :ClassMethods,   'arstotzka/class_methods'
  autoload :Crawler,        'arstotzka/crawler'
  autoload :Exception,      'arstotzka/exception'
  autoload :Fetcher,        'arstotzka/fetcher'
  autoload :FetcherBuilder, 'arstotzka/fetcher_builder'
  autoload :KeyChanger,     'arstotzka/key_changer'
  autoload :KeyReader,      'arstotzka/key_reader'
  autoload :HashReader,     'arstotzka/hash_reader'
  autoload :MethodBuilder,  'arstotzka/method_builder'
  autoload :Options,        'arstotzka/options'
  autoload :PostProcessor,  'arstotzka/post_processor'
  autoload :Reader,         'arstotzka/reader'
  autoload :TypeCast,       'arstotzka/type_cast'
  autoload :Wrapper,        'arstotzka/wrapper'

  configurable_by Arstotzka::Config
end
