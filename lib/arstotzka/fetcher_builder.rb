# frozen_string_literal: true

module Arstotzka
  # @api private
  #
  # Class responsible for building fetcher that will be used
  # to create instance fetchers
  #
  # @example Building a simple fetcher
  #   class MyModel
  #     include Arstotzka
  #
  #     attr_reader :json
  #
  #     def initialize(json)
  #       @json = json
  #     end
  #   end
  #
  #   options =  Arstotzka::Options.new(key: :id, path: :person)
  #   builder = Arstotzka::FetcherBuilder.new(options)
  #   instance = MyModel.new(
  #     person: {
  #       id: 101
  #     }
  #   )
  #
  #   fetcher = builder.build(instance)
  #
  #   fetcher.fetch  # returns 101
  class FetcherBuilder
    include Base

    # Creates an instance of Artotzka::FetcherBuilder
    #
    # @overload initialize(options_hash = {})
    #   @param options_hash [Hash] options (see {Options})
    #
    # @overload initialize(options)
    #   @param options [Arstotzka::Options] options
    def initialize(options_hash = {})
      self.options = options_hash
    end

    # Builds a fetcher responsible for fetchin a value
    #
    # @param instance [Object] object that includes Arstotzka
    #
    #   instance should be able to provide the hash where values
    #   will be fetched from
    #
    # @example (see Arstotzka::FetcherBuilder)
    #
    # @example Building a fetcher using full path
    #   class MyModel
    #     include Arstotzka
    #
    #     attr_reader :json
    #
    #     def initialize(json)
    #       @json = json
    #     end
    #   end
    #
    #   options =  Arstotzka::Options.new(
    #     key:       :player_ids,
    #     full_path: 'teams.players.person_id',
    #     flatten:   true,
    #     case:      :snake
    #   )
    #   builder = Arstotzka::FetcherBuilder.new(options)
    #   hash = {
    #     teams: [
    #       {
    #         name: 'Team War',
    #         players: [
    #           { person_id: 101 },
    #           { person_id: 102 }
    #         ]
    #       }, {
    #         name: 'Team not War',
    #         players: [
    #           { person_id: 201 },
    #           { person_id: 202 }
    #         ]
    #       }
    #     ]
    #   }
    #   instance = MyModel.new(hash)
    #
    #   fetcher = builder.build(instance)
    #
    #   fetcher.fetch  # returns [101, 102, 201, 202]
    #
    # @example Post processing results
    #   class StarGazer
    #     include Arstotzka
    #
    #     attr_reader :json
    #
    #     def initialize(json = {})
    #       @json = json
    #     end
    #
    #     private
    #
    #     def only_yellow(stars)
    #       stars.select(&:yellow?)
    #     end
    #   end
    #
    #   class Star
    #     attr_reader :name, :color
    #
    #     def initialize(name:, color: 'yellow')
    #       @name = name
    #       @color = color
    #     end
    #
    #     def yellow?
    #       color == 'yellow'
    #     end
    #   end
    #
    #   hash = {
    #     teams: [
    #       {
    #         name: 'Team War',
    #         players: [
    #           { person_id: 101 },
    #           { person_id: 102 }
    #         ]
    #       }, {
    #         name: 'Team not War',
    #         players: [
    #           { person_id: 201 },
    #           { person_id: 202 }
    #         ]
    #       }
    #     ]
    #   }
    #
    #   instance = StarGazer.new(hash)
    #
    #   options = Arstotzka::Options.new(
    #     key: :stars, klass: Star, after: :only_yellow
    #   )
    #
    #   builder = Arstotzka::FetcherBuilder.new(options)
    #   fetcher = builder.build(instance)
    #
    #   fetcher.fetch # returns [
    #                 #   Star.new(name: 'Sun', color: 'yellow'),
    #                 #   Star.new(name: 'HB0124-C', color: 'yellow'),
    #                 # ]
    #
    # @return Arstotzka::Fetcher
    def build(instance)
      Fetcher.new(instance, options)
    end

    private

    # @private
    attr_reader :options
  end
end
