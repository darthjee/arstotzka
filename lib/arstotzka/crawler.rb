# frozen_string_literal: true

module Arstotzka
  # Crawl a hash through the keys of keys
  #
  # @api private
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
  class Crawler
    include Base

    # Creates a new instance of Crawler
    #
    # @param keys [Array] keys of keys to be crawled
    # @param case [Symbol] case type of the keys
    #   - snake: snake_cased keys
    #   - lower_camel: lowerCamelCased keys
    #   - upper_camel: UperCamelCased keys
    # @param compact [Boolean] flag signallying if nil values should be removed of an array
    # @param default [Object] default value to be returned when failing to fetch a value
    # @param block [Proc] block to be ran over the fetched value before returning it
    def initialize(options = {}, &block)
      self.options = options

      @post_process = block || proc { |value| value }
    end

    # Crawls into the hash looking for all keys in the given keys
    # @overload value(hash)
    # @return [Object] value fetched from the last Hash#fetch call using the last part
    #   of keys
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
    #     compact: true, case: :snake
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
    #     compact: true, case: :snake, default: 'NO HERO'
    #   )
    #
    #   crawler.value(games_hash) # returns [['NO HERO', 'Rakhar'], 'NO HERO']
    #
    # @example
    #   crawler = Arstotzka::Crawler.new(
    #     %w(companies games hero),
    #     compact: true, case: :snake
    #   ) { |value| value.&to_sym }
    #
    #   crawler.value(games_hash) # returns [[:Rakhar]]
    def value(hash, index = 0)
      crawl(hash, index)
    rescue Exception::KeyNotFound
      wrap(default)
    end

    private

    # @private
    attr_reader :post_process, :options
    delegate :keys, :compact, :default, to: :options

    # Fetch the value from hash by crawling the keys
    #
    # The crawling is similar to fetching values in a chain
    # <code>
    # { a: { b: 10 } }.fetch(:a).fetch(:b)
    # </code>
    # with added features like accessing string and
    # symbol keys alike, wrapping the values in new objects,
    # post processing the values, treating arrays as collection
    # of hashes, etc...
    #
    # Once the value is found (with final key), it is wrapped
    #
    # If value found in any step (except finel step) and this
    # is an Array, then next interations will happen with it
    # element of the array, returning an array of results
    #
    # @param [Hash] hash the hash to be crawled
    # @param [Integer] index the index of the key to be used in the current iteration
    #
    # @return [Object] value found at the lest key after transformation
    #
    # @see #wrap
    # @see #crawl_array
    def crawl(hash, index = 0)
      return wrap(hash) if reader.ended?(index)
      return crawl_array(hash, index) if hash.is_a?(Array)

      crawl(reader.read(hash, index), index + 1)
    end

    # @private
    #
    # Builds a hash reader
    #
    # @return [Arstotzka::Reader] Object responsible for extracting values out of the hash
    def reader
      @reader ||= Arstotzka::Reader.new(options)
    end

    # @private
    #
    # Wrap value with final calls
    #
    # The final value can be wrapped in a class, or processed
    # via instance method call
    #
    # @param [Object] value the value to be wrapped
    # @return [Object] the post-processed / wraped value
    def wrap(value)
      post_process.call(value)
    end

    # @private
    #
    # Iterate over array applying #crawl over each element
    #
    # @param [Array] array the array of hashes be crawled
    # @param [Integer] index the index of the key to be used in the current iteration
    #
    # @return [Array] the new array with the individual values returned
    # @see #crawl
    def crawl_array(array, index)
      array.map { |j| value(j, index) }.tap do |a|
        a.compact! if compact
      end
    end
  end
end
