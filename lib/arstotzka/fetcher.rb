# frozen_string_literal: true

module Arstotzka
  # Class responsible for orquestrating the fetch value from the hash
  # and post-processing it
  class Fetcher
    include Sinclair::OptionsParser

    # @param json [Hash] Hash to be crawled for value
    # @param instance [Object] object whose methods will be called after for processing
    # @param path [String/Symbol] complete path for fetching the value from hash
    # @param options [Hash] options that will be passed to {Crawler}, {Wrapper} and {Reader}
    def initialize(json, instance, path:, **options)
      @path = path.to_s.split('.')
      @json = json
      @instance = instance
      @options = options
    end

    # Crawls the hash for the value, applying then the final transformations on the final
    # result (collection not value)
    #
    # @example
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
    #     private
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
    #   instance = Account.new
    #   fetcher = Arstotzka::Fetcher.new(hash, instance,
    #     path: 'transactions',
    #     clazz: Transaction,
    #     after: :filter_income
    #   )
    #
    #   fetcher.fetch # retruns [
    #                 #   Transaction.new(value: 1000.53, type: 'income'),
    #                 #   Transaction.new(value: 50.23, type: 'income')
    #                 # ]
    def fetch
      value = crawler.value(json)
      value.flatten! if flatten && value.respond_to?(:flatten!)
      value = instance.send(after, value) if after
      value
    end

    private

    attr_reader :path, :json, :instance

    delegate :after, :flatten, to: :options_object
    delegate :wrap, to: :wrapper

    def crawler
      @crawler ||= buidl_crawler
    end

    def buidl_crawler
      Arstotzka::Crawler.new(crawler_options) do |value|
        wrap(value)
      end
    end

    def crawler_options
      options.slice(:case_type, :compact, :default).merge(path: path)
    end

    def wrapper
      @wrapper ||= build_wrapper
    end

    def build_wrapper
      Arstotzka::Wrapper.new(wrapper_options)
    end

    def wrapper_options
      options.slice(:clazz, :type)
    end
  end
end
