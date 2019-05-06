# frozen_string_literal: true

module Arstotzka
  class HashReader
    include Base

    def initialize(options_hash = {})
      self.options = options_hash
    end

    # Retrieves the hash to be crawled from the instance
    #
    # @return [Hash]
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
