# frozen_string_literal: true

module Arstotzka
  class Fetcher
    class Dummy
      def initialize(json = {})
        @json = json
      end

      private

      attr_reader :json
    end
  end
end
