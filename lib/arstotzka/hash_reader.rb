# frozen_string_literal: true

module Arstotzka
  # @api private
  #
  # Class responsible for reading json / hash from instance
  class HashReader
    include Base

    # Retrieves the hash to be crawled from the instance
    #
    # @return [Hash]
    #
    # @example Simple Usage
    #   class Dummy
    #     def initialize(json = {})
    #       @json = json
    #     end
    #
    #     private
    #
    #     attr_reader :json
    #   end
    #
    #   hash = { key: 'value' }
    #   instance = Dummy.new(hash)
    #
    #   reader = Arstotzka::HashReader.new(
    #     instance: instance
    #   )
    #
    #   reader.hash # returns { key: 'value' }
    #
    # @example When fetching from class variable
    #   class ClassVariable
    #     def self.json=(json)
    #       @@json = json
    #     end
    #   end
    #
    #   hash = { key: 'value' }
    #   ClassVariable.json = hash
    #
    #   instance = ClassVariable.new
    #
    #   reader = Arstotzka::HashReader.new(
    #     instance: instance, json: :@@json
    #   )
    #
    #   reader.hash # returns { key: 'value' }
    def hash
      @hash ||= case json.to_s
                when /^@@.*/
                  instance.class.class_variable_get(json)
                when /^@.*/
                  then instance.instance_variable_get(json)
                else
                  instance.send(json)
                end
    end

    private

    attr_reader :options

    delegate :instance, to: :options
    delegate :json, to: :options
  end
end
