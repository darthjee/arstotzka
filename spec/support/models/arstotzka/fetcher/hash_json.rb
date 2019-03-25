# frozen_string_literal: true

module Arstotzka
  class Fetcher
    class HashJson
      def initialize(hash)
        @hash = hash
      end

      private

      attr_reader :hash
    end
  end
end
