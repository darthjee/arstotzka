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
  #   options = { key: :id, path: :person }
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
    # Creates an instance of Artotzka::FetcherBuilder
    #
    # @param options [Hash] options (see {Options})
    def initialize(options = {})
      @options = options
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
    #   options = {
    #     key:       :player_ids,
    #     full_path: 'teams.players.person_id',
    #     flatten:   true,
    #     case:      :snake
    #   }
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
    #   options = {
    #     key: :stars, klass: Star, after: :only_yellow
    #   }
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
      fetcher_options = Arstotzka.config.options(
        options.merge(instance: instance)
      )

      Fetcher.new(fetcher_options)
    end

    private

    # @private
    attr_reader :options
  end
end
