require 'active_support'
require 'active_support/all'

module JsonParser
  extend ActiveSupport::Concern

  require 'json_parser/version'
  require 'json_parser/post_processor'
  require 'json_parser/fetcher'
  require 'json_parser/class_methods'
end
