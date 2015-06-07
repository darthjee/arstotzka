require 'active_support'
require 'active_support/all'

module JsonParser
  extend ActiveSupport::Concern

  require 'concerns/type_cast'
  require 'concerns/options_parser'
  require 'json_parser/version'
  require 'json_parser/crawler'
  require 'json_parser/wrapper'
  require 'json_parser/fetcher'
  require 'json_parser/class_methods'
  require 'json_parser/class_methods/builder'
end
