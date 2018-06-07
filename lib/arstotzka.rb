require 'active_support'
require 'active_support/all'
require 'sinclair'

module Arstotzka
  extend ActiveSupport::Concern

  autoload :Builder,      'arstotzka/builder'
  autoload :ClassMethods, 'arstotzka/class_methods'
  autoload :Crawler,      'arstotzka/crawler'
  autoload :Exception,    'arstotzka/exception'
  autoload :Fetcher,      'arstotzka/fetcher'
  autoload :Reader,       'arstotzka/reader'
  autoload :Wrapper,      'arstotzka/wrapper'
  autoload :TypeCast,     'arstotzka/type_cast'
end
