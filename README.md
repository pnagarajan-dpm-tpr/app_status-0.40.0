# AppStatus

## Disable HealthMetric in RailsApp in initializer

### Rack apps:

    AppStatus.configure do |config|
      config.health_metric_enabled = false
    end

### Rails apps:

File:

    config/application.rb

Code:

    module MyApp
      class Application < Rails::Application
        config.before_initialize do
          AppStatus.configure do |app_status_config|
            app_status_config.health_metric_enabled = false
          end
        end
      end
    end

