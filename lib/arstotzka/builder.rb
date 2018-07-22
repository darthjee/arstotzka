# frozen_string_literal: true

module Arstotzka
  # Class responsible to orchestrate the addtion of method that will
  # crawl the hash for value
  #
  # @example
  #   class MyModel
  #     attr_reader :json
  #
  #     def initialize(json)
  #       @json = json
  #     end
  #   end
  #
  #   instance = MyModel.new(
  #     'name' => { first: 'John', last: 'Williams' },
  #     :age => '20',
  #     'cars' => 2.0
  #   )
  #
  #   builder = Arstotzka::Builder.new([ :first_name ], MyModel, full_path: 'name.first')
  #   builder.build
  #
  #   instance.first_name # returns 'John'
  #
  #   builder = Arstotzka::Builder.new([ :age, :cars ], MyModel, type: :integer)
  #   builder.build
  #
  #   instance.age  # returns 20
  #   instance.cars # returns 2
  #
  # @see https://www.rubydoc.info/gems/sinclair Sinclair
  class Builder < Sinclair
    DEFAULT_OPTIONS = {
      after:     false,
      case:      :lower_camel,
      class:     nil,
      compact:   false,
      default:   nil,
      flatten:   false,
      json:      :json,
      type:      :none
    }.freeze

    # @param attr_names [Array] list of attributes to be fetched from the hash/json
    # @param clazz [Class] class to receive the methods
    # @param path [String/Symbol] path of hash attributes to find the root
    #   where the attribute live (then fetching it using the attribute name)
    # @param full_path [String/Symbol] path of hash attributes to find exacttly where the
    #   value live (ignoring the attribute name)
    # @param cached [Boolean] flag if the result should be memorized instead of repeating
    #   the crawling
    # @param json [String/Symbol] name of the method containing the Hash/json to be crawled
    # @param options [Hash] hash containing extra options
    # @option options [String/Symbol] case:  {Reader} flag definining on which case will the keys be defined
    #   - lower_camel: keys in the hash are lowerCamelCase
    #   - upper_camel: keys in the hash are UpperCamelCase
    #   - snake: keys in the hash are snake_case
    # @option options [Boolean] compact:  {Crawler} flag to apply Array#compact thus removing nil results
    # @option options [Class] class:  {Fetcher} option thatwhen passed, wraps the result in an
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
    def initialize(attr_names, clazz,
                   json: :json, path: nil, full_path: nil, cached: false,
                   **options)
      super(clazz, DEFAULT_OPTIONS.merge(options.symbolize_keys))

      @attr_names = attr_names
      @path = path
      @full_path = full_path
      @cached = cached
      @json_name = json
      init
    end

    private

    attr_reader :attr_names, :json_name, :path, :full_path, :cached

    def init
      attr_names.each do |attr|
        add_attr(attr)
      end
    end

    def real_path(attribute)
      full_path || [path, attribute].compact.join('.')
    end

    def wrapper_clazz
      options[:class]
    end

    def case_type
      options[:case]
    end

    def fetcher_options(attribute)
      options.slice(:compact, :after, :type, :flatten, :default).merge(
        clazz: wrapper_clazz,
        case_type: case_type,
        path: real_path(attribute)
      )
    end

    def add_attr(attribute)
      add_method attribute, (cached ? cached_fetcher(attribute) : attr_fetcher(attribute)).to_s
    end

    def attr_fetcher(attribute)
      <<-CODE
      ::Arstotzka::Fetcher.new(
        #{json_name}, self, #{fetcher_options(attribute)}
      ).fetch
      CODE
    end

    def cached_fetcher(attribute)
      <<-CODE
      @#{attribute} ||= #{attr_fetcher(attribute)}
      CODE
    end
  end
end
