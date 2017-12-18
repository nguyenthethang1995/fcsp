ENV["RAILS_ENV"] ||= "test"
require "simplecov"
require "webmock"

SimpleCov.start "rails"
WebMock.allow_net_connect!

require File.expand_path("../../config/environment", __FILE__)
require "spec_helper"
require "rspec/rails"
require "shoulda/matchers"
require "capybara/rails"
require_relative "support/database_cleaner"
require "support/factory_bot"
require "support/shoulda_matchers_fix_serizalize_attributes"
require 'database_cleaner'
if Rails.env.production?
  abort("The Rails environment is running in production mode!")
end

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

include Warden::Test::Helpers
Warden.test_mode!

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include ControllerHelpers, type: :controller

  config.after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end
end

Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end
Capybara.javascript_driver = :selenium_chrome
