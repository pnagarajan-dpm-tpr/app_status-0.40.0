require "app_status/config"
require "app_status/rack"
require "app_status/activemq"
require "app_status/database"
require "app_status/dependency"
require "app_status/cluster_dependency"
require "app_status/elasticsearch"
require "app_status/health_metric"
require "app_status/http_status_middleware"
require "app_status/memcached"
require "app_status/migrations"
require "app_status/was"
require "app_status/railtie" if defined?(Rails)

module AppStatus
  class << self
    delegate :health_metric_enabled, to: :config

    def configure
      yield config
    end

    def config
      @config ||= AppStatus::Config.new
    end
  end
end
