# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'json_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "json_parser"
  spec.version       = JsonParser::VERSION
  spec.authors       = ["Bidu Dev's Team"]
  spec.email         = ["dev@bidu.com.br"]
  spec.summary       = "Json Parser"
  spec.description   = spec.description
  spec.homepage      = "https://github.com/Bidu/json_parser"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f)  }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'activesupport', '~> 5.x'
  spec.add_runtime_dependency 'concern_builder'

  spec.add_development_dependency 'safe_attribute_assignment'
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency 'simplecov'
end
