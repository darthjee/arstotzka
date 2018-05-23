require 'active_support'
require 'active_support/all'
require 'sinclair'

module JsonParser
  extend ActiveSupport::Concern

  require 'json_parser/type_cast'
  require 'json_parser/version'
  require 'json_parser/crawler'
  require 'json_parser/wrapper'
  require 'json_parser/fetcher'
  require 'json_parser/class_methods'
  require 'json_parser/builder'
end
