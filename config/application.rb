require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TtsWebapp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.encoding = "utf-8"
    config.active_job.queue_adapter = :sidekiq
    #config.active_job.queue_name_prefix = Rails.env
    # for development:
    Rails.application.config.hosts.clear
    #Rails.application.config.hosts << "final-url.com"

    # Cors settings
    # Reference: https://github.com/cyu/rack-cors
    #config.middleware.insert_before 0, Rack::Cors do
    #  allow do
    #    origins '*'
    #    resource '*', headers: :any, methods: [:get, :post, :put, :options]
    #  end
    #end

    logger = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end
end
