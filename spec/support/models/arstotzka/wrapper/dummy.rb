# frozen_string_literal: true

module Arstotzka
  class Wrapper
    class Dummy
      attr_reader :value
      def initialize(value)
        @value = value
      end
    end
  end
end
