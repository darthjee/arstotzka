# frozen_string_literal: true

module Arstotzka
  class Fetcher
    class NoAccessor
      def initialize(hash)
        @hash = hash
      end
    end
  end
end
