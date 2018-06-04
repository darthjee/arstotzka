require 'active_support'
require 'active_support/all'
require 'sinclair'

module JsonParser
  extend ActiveSupport::Concern

  autoload :TypeCast,     'json_parser/type_cast'
  autoload :Crawler,      'json_parser/crawler'
  autoload :Wrapper,      'json_parser/wrapper'
  autoload :Fetcher,      'json_parser/fetcher'
  autoload :ClassMethods, 'json_parser/class_methods'
  autoload :Builder,      'json_parser/builder'
  autoload :Reader,       'json_parser/reader'
  autoload :Exception,    'json_parser/exception'
end
