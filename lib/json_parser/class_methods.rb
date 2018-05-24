module JsonParser
  module ClassMethods
    def json_parse(*attr_names)
      options = attr_names.extract_options!

      builder = Builder.new(attr_names, self, options)
      builder.build
    end
  end
end
