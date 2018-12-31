require_relative 'boot'

require 'rails/all'
require 'rack/rewrite/yaml_rule_set'
require_relative '../lib/strip_x_forwarded_host'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LocationMachine
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.eager_load_paths << Rails.root.join('lib')

    config.middleware.use(Rack::Rewrite,
        klass: Rack::Rewrite::YamlRuleSet,
        options: {
          file_name: Rails.root.join('config', 'rewrite.yml')
        }
    )
    config.middleware.use Rack::Deflater
    config.middleware.use StripXForwardedHost
  end
end
