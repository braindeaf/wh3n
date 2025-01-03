# frozen_string_literal: true

plugin_test_dir = File.dirname(__FILE__)

require 'rubygems'
require 'bundler/setup'
require 'pry'

require 'logger'
require 'active_record'
require 'active_support'
ActiveRecord::Base.logger = Logger.new(plugin_test_dir + "/debug.log")

require 'yaml'
require 'erb'
db_config = YAML::load(ERB.new(IO.read(plugin_test_dir + "/db/database.yml")).result)
ActiveRecord::Base.configurations = db_config
ActiveRecord::Base.establish_connection((ENV["DB"] ||= "sqlite3mem").to_sym)
ActiveRecord::Migration.verbose = false

unless /sqlite/ === ENV['DB']
  ActiveRecord::Tasks::DatabaseTasks.create db_config[ENV['DB']]
end

load(File.join(plugin_test_dir, "db", "schema.rb"))

require 'wh3n'
require 'support/models'

begin
  require 'action_view'
rescue LoadError; end # action_view doesn't exist in Rails 4.0, but we need this for the tests to run with Rails 4.1

require 'action_controller'
require 'rspec/rails'
# require 'database_cleaner'

# RSpec.configure do |config|
#   # config.fixture_path = "#{plugin_test_dir}/fixtures"
#   config.use_transactional_fixtures = true
#   config.after(:suite) do
#     unless /sqlite/ === ENV['DB']
#       ActiveRecord::Tasks::DatabaseTasks.drop db_config[ENV['DB']]
#     end
#   end
# end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
