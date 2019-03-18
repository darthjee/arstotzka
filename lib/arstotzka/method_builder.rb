# frozen_string_literal: true

module Arstotzka
  # Class responsible to orchestrate the addtion of method that will
  # crawl the hash for value
  #
  # @api private
  #
  # @example
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
  #   instance = MyModel.new(
  #     'name' => { first: 'John', last: 'Williams' },
  #     :age => '20',
  #     'cars' => 2.0
  #   )
  #
  #   options = Arstotzka::Options.new(full_path: 'name.first')
  #   builder = Arstotzka::MethodBuilder.new([ :first_name ], MyModel, options)
  #   builder.build
  #
  #   instance.first_name # returns 'John'
  #
  #   options = Arstotzka::Options.new(type: :integer)
  #   builder = Arstotzka::MethodBuilder.new([ :age, 'cars' ], MyModel, options)
  #   builder.build
  #
  #   instance.age  # returns 20
  #   instance.cars # returns 2
  #
  # @see https://www.rubydoc.info/gems/sinclair Sinclair
  class MethodBuilder < Sinclair
    include Base
    # Returns new instance of Arstotzka::MethodBuilder
    #
    # @param attr_names [Array] list of attributes to be fetched from the hash/json
    # @param klass [Class] class to receive the methods
    #   (using {https://www.rubydoc.info/gems/sinclair Sinclair})
    #
    # @overload initialize(attr_names, klass, options_hash={})
    #   @param options_hash [Hash] hash containing extra options
    #
    # @overload initialize(attr_names, klass, options)
    #   @param options [Arstotzka::Options] options of initialization object
    #
    # @see https://www.rubydoc.info/gems/sinclair Sinclair
    # @see Arstotzka::Options
    def initialize(attr_names, klass, options = {})
      super(klass)
      self.options = options

      @attr_names = attr_names
      init
    end

    private

    # @private
    attr_reader :attr_names, :options
    delegate :path, :full_path, :cached, to: :options

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
    # Add method to the list of methods to be built
    #
    # @param [String,Symbol] attribute name of method / attribute
    #
    # @return nil
    #
    # @see Sinclair
    def add_attr(attribute)
      klass.add_fetcher(attribute, options)
      add_method attribute, (cached ? cached_fetcher(attribute) : attr_fetcher(attribute)).to_s
    end

    # Returns the code needed to initialize fetcher
    #
    # @param [String,Symbol] attribute name of method / attribute
    #
    # @return [String] method code
    #
    # @see Sinclair
    # @see Artotzka::Fetcher
    def attr_fetcher(attribute)
      <<-CODE
        begin
          self.class.fetcher_for(:#{attribute}, self).fetch
        end
      CODE
    end

    # Returns the code needed to initialize a fetche and cache it
    #
    # @param [String,Symbol] attribute name of method / attribute
    #
    # @return [String] method code
    #
    # @see #attr_fetcher
    def cached_fetcher(attribute)
      <<-CODE
        @#{attribute} ||= #{attr_fetcher(attribute)}
      CODE
    end
  end
end
