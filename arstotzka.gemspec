# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arstotzka/version'

Gem::Specification.new do |gem|
  gem.name                  = 'arstotzka'
  gem.version               = Arstotzka::VERSION
  gem.authors               = ['Darthjee']
  gem.email                 = ['dev@gmail.com']
  gem.summary               = 'Arstotzka'
  gem.description           = 'Fetch values from nested hashes / JSON declaratively'
  gem.homepage              = 'https://github.com/darthjee/arstotzka'
  gem.required_ruby_version = '>= 3.4.0'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.require_paths = ['lib']

  gem.add_dependency 'activesupport', '>= 7.2.4'
  gem.add_dependency 'sinclair',      '>= 3.2.0'
end
