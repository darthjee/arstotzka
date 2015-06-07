module JsonParser::ClassMethods

  def json_parse(*attr_names)
    options = {
      path: nil,
      json: :json,
      full_path: nil,
      cached: false,
      class: nil,
      compact: false,
      after: false,
      case: :lower_camel,
      type: :none
    }.merge(attr_names.extract_options!)

    builder = Builder.new(attr_names, self, options)
    builder.build
  end
end
