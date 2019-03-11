# frozen_string_literal: true

module Arstotzka
  module Base
    private

    def options=(options)
      @options = if options.is_a?(Hash)
                   Options.new(options)
                 else
                   options
        end
    end
  end
end
