ENV["RAILS_ENV"] ||= "test"

# Start SimpleCov before loading any application code
require 'simplecov'
require 'simplecov-html'

SimpleCov.start 'rails' do
  add_filter '/spec/'
  add_filter '/test/'
  add_filter '/vendor/'

  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Helpers', 'app/helpers'
  add_group 'Views', 'app/views'
  add_group 'Libraries', 'lib'

  formatter SimpleCov::Formatter::HTMLFormatter
end

# Load the dummy Rails application
require File.expand_path('dummy/config/environment', __dir__)

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
    end
  end

  # Set default locale to en for consistency
  config.before do
    I18n.default_locale = :en
    I18n.locale = :en
  end
end

# Load support files
spec_root = File.expand_path('..', __dir__)
Dir[File.join(spec_root, 'spec', 'support', '**', '*.rb')].sort.each { |f| require f }