# frozen_string_literal: true

module Arstotzka
  # @api private
  #
  # Class responsible for orquestrating the fetch value from the hash
  # and post-processing it
  class Fetcher
    include Base

    # Creates an instance of Artotzka::Fetcher
    #
    # @overload iniitalize(options_hash = {})
    #   @param options_hash [Hash] options for {Crawler}, {Wrapper},
    #   {Reader} and {HashReader}
    #
    # @overload iniitalize(options)
    #   @param options [Arstotzka::Options] options for {Crawler}, {Wrapper},
    #   {Reader} and {HashReader}
    def initialize(options_hash = {})
      self.options = options_hash
    end

    # Crawls the hash for the value
    #
    # After the crawling, final transformation is applied on
    # the final result (collection not value)
    #
    # @return [Object] The final value found and transformed
    #
    # @example Fetching with wrapping and processing
    #   class Transaction
    #     attr_reader :value, :type
    #
    #     def initialize(value:, type:)
    #       @value = value
    #       @type = type
    #     end
    #
    #     def positive?
    #       type == 'income'
    #     end
    #   end
    #
    #   class Account
    #     def initialize(json = {})
    #       @json = json
    #     end
    #
    #     private
    #
    #     attr_reader :json
    #
    #     def filter_income(transactions)
    #       transactions.select(&:positive?)
    #     end
    #   end
    #
    #   hash = {
    #     transactions: [
    #       { value: 1000.53, type: 'income' },
    #       { value: 324.56,  type: 'outcome' },
    #       { value: 50.23,   type: 'income' },
    #       { value: 150.00,  type: 'outcome' },
    #       { value: 10.23,   type: 'outcome' },
    #       { value: 100.12,  type: 'outcome' },
    #       { value: 101.00,  type: 'outcome' }
    #     ]
    #   }
    #
    #   instance = Account.new
    #
    #   fetcher = Arstotzka::Fetcher.new(
    #     instance: instance,
    #     path:     'transactions',
    #     klass:    Transaction,
    #     after:    :filter_income
    #   )
    #
    #   fetcher.fetch # retruns [
    #                 #   Transaction.new(value: 1000.53, type: 'income'),
    #                 #   Transaction.new(value: 50.23, type: 'income')
    #                 # ]
    def fetch
      if cached
        fetch_with_cache
      else
        fetch_value
      end
    end

    # Checks if other equals self
    #
    # @param other [Object]
    #
    # @return [TrueClass,FalseClass]
    def ==(other)
      return false unless other.class == self.class
      options == other.options &&
        instance == other.instance
    end

    protected

    attr_reader :options

    private

    # @private
    delegate :cached, :key, :instance, :after, :flatten, to: :options
    delegate :wrap, to: :wrapper
    delegate :hash, to: :hash_reader

    def fetch_with_cache
      if is_cached?
        fetch_from_cache
      else
        instance.instance_variable_set(
          "@#{key}", fetch_value
        )
      end
    end

    def fetch_from_cache
      instance.instance_variable_get("@#{key}")
    end

    def is_cached?
      if cached == :full
        instance.instance_variable_defined?("@#{key}")
      else
        instance.instance_variable_get("@#{key}")
      end
    end

    def fetch_value
      value = crawler.value(hash)
      value.flatten! if flatten && value.is_a?(Array)
      value = instance.send(after, value) if after
      value
    end

    # @private
    #
    # Returns an instance of Aristotzka::Craler
    #
    # craler will be responsible to crawl the hash for
    # the final return
    #
    # @return [Arstotzka::Crawler] the crawler object
    def crawler
      @crawler ||=
        Crawler.new(options) do |value|
          wrap(value)
        end
    end

    # @private
    #
    # Wrapper responsible for wrapping the value found
    #
    # @return [Arstotzka::Wrapper] the wrapper
    def wrapper
      @wrapper ||= Wrapper.new(options.merge(instance: instance))
    end

    # @api private
    #
    # Reader responsible for fetching hash from instance
    #
    # @return [Arstotzka::HashReader]
    def hash_reader
      @hash_reader ||= HashReader.new(options)
    end
  end
end
