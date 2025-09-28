# frozen_string_literal: true

require_relative "application"

# Ensure the engine code is loaded
require "bundler/setup"
require "adva"
require "adva_blog"

Dummy::Application.configure do
  config.consider_all_requests_local = true
  # Enable exception handling to convert ActiveRecord::RecordNotFound to 404
  config.action_dispatch.show_exceptions = true
  config.action_dispatch.show_detailed_exceptions = false
end

# Configure SQLite database for tests
require "fileutils"
FileUtils.mkdir_p(File.expand_path("../../tmp", __dir__))
db_path = File.expand_path("../../tmp/test.sqlite3", __dir__)

# Remove existing database to start fresh
FileUtils.rm_f(db_path) if File.exist?(db_path)

# Now initialize the application
Dummy::Application.initialize!

# Run adva migrations after app initialization
adva_migrations_path = File.expand_path("../../../../../adva/db/migrate", __FILE__)
if Dir.exist?(adva_migrations_path)
  migrations_paths = [adva_migrations_path]
  if defined?(ActiveRecord::MigrationContext)
    context = ActiveRecord::MigrationContext.new(migrations_paths)
    if context.respond_to?(:migrate)
      context.migrate
    else
      context.up
    end
  else
    ActiveRecord::Migrator.migrate(migrations_paths)
  end
end

# Load the engine's routes if they exist
adva_routes = File.expand_path("../../../../adva/config/routes.rb", __FILE__)
load adva_routes if File.exist?(adva_routes)

# Load minimal data for tests if available
adva_seed_file = File.expand_path("../../../../adva/spec/internal/db/seed_for_tests.rb", __FILE__)
load adva_seed_file if File.exist?(adva_seed_file)