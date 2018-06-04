require 'active_support'
require 'active_support/all'
require 'sinclair'

module JsonParser
  extend ActiveSupport::Concern

  autoload :Builder,      'json_parser/builder'
  autoload :ClassMethods, 'json_parser/class_methods'
  autoload :Crawler,      'json_parser/crawler'
  autoload :Exception,    'json_parser/exception'
  autoload :Fetcher,      'json_parser/fetcher'
  autoload :Reader,       'json_parser/reader'
  autoload :Wrapper,      'json_parser/wrapper'
  autoload :TypeCast,     'json_parser/type_cast'
end
