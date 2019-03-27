# frozen_string_literal: true

require 'simplecov'
SimpleCov.start do
  add_filter 'spec/support/models/'
end

require 'pry-nav'
require 'arstotzka'
require 'safe_attribute_assignment'
require 'sinclair/matchers'

support_files = File.expand_path('spec/support/**/*.rb')
Dir[support_files].sort.each { |file| require file }

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.filter_run_excluding :integration unless ENV['ALL']

  config.include Sinclair::Matchers

  config.order = 'random'

  config.before do
  end
end
