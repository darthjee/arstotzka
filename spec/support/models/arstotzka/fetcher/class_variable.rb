# frozen_string_literal: true

module Arstotzka
  class Fetcher
    class ClassVariable
      def self.json=(json)
        @@json = json
      end
    end
  end
end
