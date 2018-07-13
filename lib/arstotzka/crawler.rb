# frozen_string_literal: true

module Arstotzka
  # Crawl a json/hash through the path of keys
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
    attr_reader :post_process, :path, :case_type, :compact, :default

    def initialize(path:, case_type: :lower_camel, compact: false, default: nil, &block)
      @case_type = case_type
      @compact = compact
      @default = default
      @path = path
      @post_process = block || proc { |value| value }
    end

    def value(json, index = 0)
      crawl(json, index)
    rescue Exception::KeyNotFound
      wrap(default)
    end

    private

    def crawl(json, index = 0)
      return wrap(json) if reader.ended?(index)
      return crawl_array(json, index) if json.is_a?(Array)

      crawl(reader.read(json, index), index + 1)
    end

    def reader
      @reader ||= Arstotzka::Reader.new(
        path: path,
        case_type: case_type
      )
    end

    def wrap(json)
      post_process.call(json)
    end

    def crawl_array(array, index)
      array.map { |j| value(j, index) }.tap do |a|
        a.compact! if compact
      end
    end
  end
end
