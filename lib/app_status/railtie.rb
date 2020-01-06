require_relative "health_metric"
require_relative "http_status_middleware"

module AppStatus
  class Railtie < Rails::Railtie
    initializer "app_status.insert_middleware" do |app|
      if AppStatus.health_metric_enabled
        app.config.middleware.use HttpStatusMiddleware
      end
    end

    config.after_initialize do
      if AppStatus.health_metric_enabled
        HealthMetric.supervise_as :health_metric
      end
      AppStatus::Logger = Rails.logger
    end
  end
end
