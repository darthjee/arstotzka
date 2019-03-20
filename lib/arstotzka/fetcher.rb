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
    # @param instance [Object] object whose methods will be called after for processing
    #
    # @overload iniitalize(instance,  options_hash = {})
    #   @param options_hash [Hash] options for {Crawler}, {Wrapper} and {Reader}
    #
    # @overload iniitalize(instance,  options)
    #   @param options [Arstotzka::Options] options for {Crawler}, {Wrapper} and {Reader}
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
    #   fetcher = Arstotzka::Fetcher.new(instance,
    #     path: 'transactions',
    #     klass: Transaction,
    #     after: :filter_income
    #   )
    #
    #   fetcher.fetch # retruns [
    #                 #   Transaction.new(value: 1000.53, type: 'income'),
    #                 #   Transaction.new(value: 50.23, type: 'income')
    #                 # ]
    def fetch
      value = crawler.value(hash)
      value.flatten! if flatten && value.respond_to?(:flatten!)
      value = instance.send(after, value) if after
      value
    end

    private

    # @private
    attr_reader :instance, :options
    delegate :instance, :after, :flatten, to: :options
    delegate :wrap, to: :wrapper

    def hash
      @hash ||= instance.send(:eval, options.json.to_s)
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
  end
end
