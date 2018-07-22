# frozen_string_literal: true

module Arstotzka
  # Crawl a hash through the path of keys
  # @example
  #   crawler = Arstotzka::Crawler.new(%w(person information first_name))
  #   hash = {
  #     person: {
  #       'information' => {
  #         'firstName' => 'John'
  #       }
  #     }
  #   }
  #   crawler.value(hash) # returns 'John'
  class Crawler
    # @param path [Array] path of keys to be crawled
    # @param case_type [Symbol] case type of the keys
    #   - snake: snake_cased keys
    #   - lower_camel: lowerCamelCased keys
    #   - upper_camel: UperCamelCased keys
    # @param compact [Boolean] flag signallying if nil values should be removed of an array
    # @param default [Object] default value to be returned when failing to fetch a value
    # @param block [Proc] block to be ran over the fetched value before returning it
    def initialize(path:, case_type: :lower_camel, compact: false, default: nil, &block)
      @case_type = case_type
      @compact = compact
      @default = default
      @path = path
      @post_process = block || proc { |value| value }
    end

    # crawls into the hash looking for all keys in the given path
    # returning the final value
    #
    # @overload value(hash)
    # @return [Object] value fetched from the last Hash#fetch call using the last part
    #   of path
    #
    # @example
    #   crawler = Arstotzka::Crawler.new(%w(person information first_name))
    #   hash = {
    #     person: {
    #       'information' => {
    #         'firstName' => 'John'
    #       }
    #     }
    #   }
    #   crawler.value(hash) # returns 'John'
    #
    # @example
    #   crawler = Arstotzka::Crawler.new(
    #     %w(companies games hero),
    #     compact: true, case_type: :snake
    #   )
    #   games_hash = {
    #     'companies' => [{
    #       name: 'Lucas Pope',
    #       games: [{
    #         'name' => 'papers, please'
    #       }, {
    #         'name' => 'TheNextBigThing',
    #         hero_name: 'Rakhar'
    #       }]
    #     }, {
    #       name: 'Old Company'
    #     }]
    #   }
    #
    #   crawler.value(games_hash) # returns [['Rakhar']]
    #
    # @example
    #   crawler = Arstotzka::Crawler.new(
    #     %w(companies games hero),
    #     compact: true, case_type: :snake, default: 'NO HERO'
    #   )
    #
    #   crawler.value(games_hash) # returns [['NO HERO', 'Rakhar'], 'NO HERO']
    #
    # @example
    #   crawler = Arstotzka::Crawler.new(
    #     %w(companies games hero),
    #     compact: true, case_type: :snake
    #   ) { |value| value.&to_sym }
    #
    #   crawler.value(games_hash) # returns [[:Rakhar]]
    def value(hash, index = 0)
      crawl(hash, index)
    rescue Exception::KeyNotFound
      wrap(default)
    end

    private

    attr_reader :post_process, :path, :case_type, :compact, :default

    def crawl(hash, index = 0)
      return wrap(hash) if reader.ended?(index)
      return crawl_array(hash, index) if hash.is_a?(Array)

      crawl(reader.read(hash, index), index + 1)
    end

    def reader
      @reader ||= Arstotzka::Reader.new(
        path: path,
        case_type: case_type
      )
    end

    def wrap(hash)
      post_process.call(hash)
    end

    def crawl_array(array, index)
      array.map { |j| value(j, index) }.tap do |a|
        a.compact! if compact
      end
    end
  end
end
