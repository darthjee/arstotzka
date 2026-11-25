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
  gem.description           = gem.description
  gem.homepage              = 'https://github.com/darthjee/arstotzka'
  gem.required_ruby_version = '>= 3.4.0'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'activesupport', '>= 7.2.4'
  gem.add_runtime_dependency 'sinclair',      '>= 3.1.0'

  gem.add_development_dependency 'bundler',            '>= 4.0.24'
  gem.add_development_dependency 'pry',                '0.14.2'
  gem.add_development_dependency 'pry-nav',            '1.0.0'
  gem.add_development_dependency 'rake',               '13.4.2'
  gem.add_development_dependency 'reek',               '6.5.0'
  gem.add_development_dependency 'rspec',              '3.13.2'
  gem.add_development_dependency 'rspec-core',         '3.13.7'
  gem.add_development_dependency 'rspec-expectations', '3.13.6'
  gem.add_development_dependency 'rspec-mocks',        '3.13.9'
  gem.add_development_dependency 'rspec-support',      '3.13.8'
  gem.add_development_dependency 'rubocop',            '1.92.2'
  gem.add_development_dependency 'rubocop-rake',       '0.7.1'
  gem.add_development_dependency 'rubocop-rspec',      '3.10.2'
  gem.add_development_dependency 'rubycritic',         '5.0.0'
  gem.add_development_dependency 'simplecov',          '0.22.0'
  gem.add_development_dependency 'simplecov-html',     '0.13.2'
  gem.add_development_dependency 'simplecov-lcov',     '0.9.0'
  gem.add_development_dependency 'yard',               '0.9.45'
  gem.add_development_dependency 'yardstick',          '0.9.9'

  gem.add_development_dependency 'safe_attribute_assignment'
end
