require 'simplecov'
SimpleCov.start

require 'pry-nav'
require 'json_parser'
require 'safe_attribute_assignment'

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
