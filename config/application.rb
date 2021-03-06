# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Prevy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.autoload_paths += Dir["#{config.root}/app/jobs/**/"]
    config.autoload_paths += Dir["#{config.root}/app/queries/**/"]
    config.autoload_paths += Dir["#{config.root}/app/services/**/**/"]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Active Job settings
    config.active_job.queue_adapter = :sucker_punch
  end
end
