ENV["RAILS_ENV"] ||= "test"

require "spec_helper"

# Load the internal Rails application
require File.expand_path('internal/config/environment', __dir__)

# Load RSpec Rails
require 'rspec/rails'
require 'rails-controller-testing'

# Basic RSpec configuration
RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  # Include rails-controller-testing helpers
  config.include Rails::Controller::Testing::TestProcess, type: :controller
  config.include Rails::Controller::Testing::TemplateAssertions, type: :controller
  config.include Rails::Controller::Testing::Integration, type: :controller

  # Include template assertions for request specs
  config.include Rails::Controller::Testing::TemplateAssertions, type: :request

  # Disable CSRF in request specs to avoid 422 on form posts
  config.before do
    if defined?(ActionController::Base)
      ActionController::Base.allow_forgery_protection = false
      Rails.application.env_config["action_dispatch.show_detailed_exceptions"] = true
    end
  end

  # Set default locale to en for consistency
  config.before do
    I18n.default_locale = :en
    I18n.locale = :en
  end
end

# Run migrations from adva gem and any other engines
ActiveRecord::Migration.verbose = false
ActiveRecord::Tasks::DatabaseTasks.drop_current
ActiveRecord::Tasks::DatabaseTasks.create_current

# Load migrations from adva gem
adva_gem_path = Gem.loaded_specs["adva"]&.full_gem_path
if adva_gem_path && Dir.exist?(File.join(adva_gem_path, "db", "migrate"))
  ActiveRecord::Migrator.migrations_paths = [File.join(adva_gem_path, "db", "migrate")]
  ActiveRecord::Tasks::DatabaseTasks.migrate
end

# Load test data
load File.join(__dir__, "internal", "db", "seed_for_tests.rb")

# Load support files
spec_root = File.expand_path('..', __dir__)
Dir[File.join(spec_root, 'spec', 'support', '**', '*.rb')].sort.each { |f| require f }
