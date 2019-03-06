# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arstotzka/version'

Gem::Specification.new do |spec|
  spec.name          = 'arstotzka'
  spec.version       = Arstotzka::VERSION
  spec.authors       = ['Darthjee']
  spec.email         = ['dev@gmail.com']
  spec.summary       = 'Arstotzka'
  spec.description   = spec.description
  spec.homepage      = 'https://github.com/darthjee/arstotzka'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activesupport', '~> 5.x'
  spec.add_runtime_dependency 'sinclair',      '>= 1.1.1'

  spec.add_development_dependency 'bundler',       '~> 1.17.x'
  spec.add_development_dependency 'pry-nav',       '~> 0.2.4'
  spec.add_development_dependency 'rake',          '>= 12.3.1'
  spec.add_development_dependency 'rspec',         '>= 3.8'
  spec.add_development_dependency 'rubocop',       '0.58.1'
  spec.add_development_dependency 'rubocop-rspec', '1.30.0'
  spec.add_development_dependency 'simplecov',     '~> 0.16.x'
  spec.add_development_dependency 'yard',          '>= 0.9.18'
  spec.add_development_dependency 'yardstick',     '>= 0.9.9'

  spec.add_development_dependency 'safe_attribute_assignment'
end
