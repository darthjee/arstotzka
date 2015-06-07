module OptionsParser
  extend ActiveSupport::Concern

  def options_object
    @options_object ||= OpenStruct.new options
  end
end
