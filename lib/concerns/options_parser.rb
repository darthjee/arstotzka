module OptionsParser
  def options_object
    @options_object ||= OpenStruct.new options
  end
end