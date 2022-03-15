require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Safehost
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.action_controller.include_all_helpers = true
    
    config.i18n.default_locale = :en
    I18n.available_locales = [:en, :de, :ru, :uk, :fr, :it, :es, :pt]
    config.time_zone = 'Europe/Berlin'

    config.generators.assets = false
    config.generators.helper = false
    config.generators.test_framework = false

    config.action_mailer.preview_path = "#{Rails.root}/test/mailers/previews"

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
