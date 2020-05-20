# frozen_string_literal: true

module Arstotzka
  class Fetcher
    class Dummy
      def initialize(json = {})
        @json = json
      end

      private

      attr_reader :json

      def ensure_age(hash)
        hash.merge(age: 10)
      end
    end
  end
end
