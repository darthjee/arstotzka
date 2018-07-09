# frozen_string_literal: true

module Arstotzka
  module ClassMethods
    def expose(*attr_names, **options)
      Builder.new(attr_names, self, options).build
    end
  end
end
