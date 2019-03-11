# frozen_string_literal: true

module Arstotzka
  # @api private
  #
  # Class responsible to hold the options
  class Options < ::OpenStruct
    DEFAULT_OPTIONS = {
      json:      :json,
      path:      nil,
      full_path: nil,
      cached:    false,
      after:     false,
      case:      :lower_camel,
      klass:     nil,
      compact:   false,
      default:   nil,
      flatten:   false,
      type:      :none
    }.freeze

    # Creates a new instance of Options
    #
    # @param options [Hash] options hash
    #   Options hash will be merged with {DEFAULT_OPTIONS}
    # @option options [Class] klass class to receive the methods
    # @option options [String/Symbol] path path of hash attributes to find the root
    #   where the attribute live (then fetching it using the attribute name)
    # @option options [String/Symbol] full_path: path of hash attributes to find exacttly where the
    #   value live (ignoring the attribute name)
    # @option options [String/Symbol] json: name of the method containing the Hash/json to be crawled
    # @option options [Boolean] cached: flag if the result should be memorized instead of repeating
    #   the crawling
    # @option options [String/Symbol] case:  {Reader} flag definining on which case will
    #   the keys be defined
    #   - lower_camel: keys in the hash are lowerCamelCase
    #   - upper_camel: keys in the hash are UpperCamelCase
    #   - snake: keys in the hash are snake_case
    # @option options [Boolean] compact:  {Crawler} flag to apply Array#compact thus
    #   removing nil results
    # @option options [Class] klass:  {Fetcher} option thatwhen passed, wraps the result in an
    #   instance of the given class
    # @option options [String/Symbol] after:  {Fetcher} option with the name of the method to be
    #   called once the value is fetched for mapping the value
    # @option options [Boolean] flatten:  {Fetcher} flag to aplly Array#flatten thus
    #   avoing nested arrays
    # @option options [String/Symbol] type:  {Fetcher} option declaring the type of the returned
    #   value (to use casting)
    #   - integer
    #   - string
    #   - float
    #
    # @see Arstotzka::Options::DEFAULT_OPTIONS
    # @return [Arstotzka::Options]
    def initialize(options)
      options = correct_keys(options.dup)

      options = DEFAULT_OPTIONS.merge(options)

      super(options)
    end

    def case_type
      self.case
    end

    def merge(options)
      self.class.new(to_h.merge(options))
    end

    private

    def correct_keys(options)
      klass = options.delete(:class)
      warn ":class has been deprecated, prefer 'expose klass: #{klass}'" if klass
      options[:klass] ||= klass

      options
    end
  end
end
