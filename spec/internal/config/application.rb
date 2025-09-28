# frozen_string_literal: true

# Selective Railties to avoid frameworks we don't need in tests (e.g., ActionText)
require "rails"
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "action_mailer/railtie"
require "active_job/railtie"
require "adva"
require "adva_blog"

module Internal
  class Application < Rails::Application
    config.root = File.expand_path("..", __dir__)
    if Rails::VERSION::MAJOR >= 8
      config.load_defaults 8.0
    else
      config.load_defaults 7.2
    end
    config.eager_load = false
    config.hosts.clear
    config.secret_key_base = "test_secret_key_base_please_change"

    # Ensure ActiveRecord::RecordNotFound is handled as 404
    config.action_dispatch.rescue_responses.merge!(
      "ActiveRecord::RecordNotFound" => :not_found
    )

    # Enable view component instrumentation for test setup
    config.view_component.instrumentation_enabled = true if defined?(ViewComponent)

    # Disable asset pipeline for testing
    config.assets.enabled = false if defined?(Sprockets)
  end
end
