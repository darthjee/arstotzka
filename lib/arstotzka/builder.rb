# frozen_string_literal: true

module Arstotzka
  # Class responsible to orchestrate the addtion of method that will
  # crawl the hash for value
  #
  # @api private
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
  #   options = Arstotzka::Builder::DEFAULT_OPTIONS.merge(full_path: 'name.first')
  #   builder = Arstotzka::Builder.new([ :first_name ], MyModel, options)
  #   builder.build
  #
  #   instance.first_name # returns 'John'
  #
  #   options = Arstotzka::Builder::DEFAULT_OPTIONS.merge(type: :integer)
  #   builder = Arstotzka::Builder.new([ :age, :cars ], MyModel, options)
  #   builder.build
  #
  #   instance.age  # returns 20
  #   instance.cars # returns 2
  #
  # @see https://www.rubydoc.info/gems/sinclair Sinclair
  class Builder < Sinclair
    DEFAULT_OPTIONS = {
      json:     :json,
      path:     nil,
      full_path: nil,
      cached: false,
      after:     false,
      case:      :lower_camel,
      class:     nil,
      compact: false,
      default: nil,
      flatten:   false,
      type:      :none
    }.freeze

    # Returns new instance of Arstotzka::Builder
    # @param attr_names [Array] list of attributes to be fetched from the hash/json
    # @param options [Hash] hash containing extra options
    # @option optison [Class] klass: class to receive the methods
    # @option options [String/Symbol] path: path of hash attributes to find the root
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
    def initialize(attr_names, clazz, **options)
      super(clazz)

      @options = Options.new(options)

      @attr_names = attr_names
      init
    end

    private

    # @private
    attr_reader :attr_names, :options
    delegate :json_name, :path, :full_path, :cached, to: :options

    # @private
    #
    # Initialize methods list
    #
    # @return nil
    def init
      attr_names.each do |attr|
        add_attr(attr)
      end
    end

    # @private
    #
    # builds the complete key path to fetch value
    #
    # @param [String/Symbol] attribute name of the method / attribute
    #
    # @return [String] the keys path
    def real_path(attribute)
      full_path || [path, attribute].compact.join('.')
    end

    # @private
    #
    # Fetch class to wrap resulting value
    #
    # after fetching the value, when wrapper_clazz returns
    # a Class object, the value will be wrapped with
    # +wrapper_clazz.new(value)+
    #
    # @return [Class] the class to wrap the resulting value
    #
    # @see Arstotzka::Wrapper
    def wrapper_clazz
      options.klass
    end

    # @private
    #
    # Fetches the case of the keys
    #
    # case types can be
    #   - lower_camel: keys in the hash are lowerCamelCase
    #   - upper_camel: keys in the hash are UpperCamelCase
    #   - snake: keys in the hash are snake_case
    #
    # @return [Symbol/String] defined case_type
    #
    # @see Arstotzka::Reader
    def case_type
      options.to_h[:case]
    end

    # @private
    #
    # Options needed by fetcher
    #
    # @param [String/Symbol] attribute name of the method / attribute
    #
    # @return [Hash] options
    #
    # @see Arstotzka::Fetcher
    def fetcher_options(attribute)
      options.to_h.slice(:compact, :after, :type, :flatten, :default).merge(
        clazz: wrapper_clazz,
        case_type: case_type,
        path: real_path(attribute)
      )
    end

    # @private
    #
    # Add method to the list of methods to be built
    #
    # @param [String/Symbol] attribute name of method / attribute
    #
    # @return nil
    #
    # @see Sinclair
    def add_attr(attribute)
      add_method attribute, (cached ? cached_fetcher(attribute) : attr_fetcher(attribute)).to_s
    end

    def json_name
      options.json
    end

    # Returns the code needed to initialize fetcher
    #
    # @param [String/Symbol] attribute name of method / attribute
    #
    # @return [String] code
    #
    # @see Sinclair
    # @see Artotzka::Fetcher
    def attr_fetcher(attribute)
      <<-CODE
      ::Arstotzka::Fetcher.new(
        #{json_name}, self, #{fetcher_options(attribute)}
      ).fetch
      CODE
    end

    # Returns the code needed to initialize a fetche and cache it
    #
    # @param [String/Symbol] attribute name of method / attribute
    #
    # @return [String] code
    #
    # @see #attr_fetcher
    def cached_fetcher(attribute)
      <<-CODE
      @#{attribute} ||= #{attr_fetcher(attribute)}
      CODE
    end
  end
end
