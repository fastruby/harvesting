if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start do
    track_files "{lib}/**/*.rb"
    add_filter "/spec/"
  end
  if ENV["CODECOV_TOKEN"]
    require "codecov"
    SimpleCov.formatter = SimpleCov::Formatter::Codecov
  end
end

require "bundler/setup"
require 'dotenv/load'
require "harvesting"
require "webmock"
require "webmock/rspec"
require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb

  config.filter_sensitive_data('$HARVEST_ACCESS_TOKEN') { ENV['HARVEST_ACCESS_TOKEN'] }
  config.filter_sensitive_data('$HARVEST_NON_ADMIN_ACCESS_TOKEN') { ENV['HARVEST_NON_ADMIN_ACCESS_TOKEN'] }
  config.filter_sensitive_data('$HARVEST_ACCOUNT_ID') { ENV['HARVEST_ACCOUNT_ID'] }
  config.filter_sensitive_data('$HARVEST_NON_ADMIN_ACCOUNT_ID') { ENV['HARVEST_NON_ADMIN_ACCOUNT_ID'] }
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.around(:each, :vcr) do |example|
    name = example.metadata[:full_description].split(/\s+/, 2).join("/").gsub(/[^\w\/]+/, "_")

    VCR.use_cassette(name) { example.call }
  end
end

require_relative './harvesting/harvest_data_setup'
