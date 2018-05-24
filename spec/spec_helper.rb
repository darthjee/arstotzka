require 'simplecov'
SimpleCov.start

require 'pry-nav'
require 'json_parser'
require 'safe_attribute_assignment'

module JsonParser
  models = File.expand_path("spec/support/models/*.rb")
  Dir[models].each do |file|
    autoload file.gsub(/.*\/(.*)\..*/, '\1').camelize.to_sym, file
  end
end
support_files = File.expand_path("spec/support/**/*.rb")
Dir[support_files].each { |file| require file  }

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.filter_run_excluding :integration unless ENV['ALL']

  config.order = 'random'

  config.before do
  end
end
