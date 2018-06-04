module Arstotzka
  module ClassMethods
    def json_parse(*attr_names, **options)
      Builder.new(attr_names, self, options).build
    end
  end
end
