require "celluloid"

module AppStatus
  class HttpStatusMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env).tap do |response|
        if response.first == 404
          Celluloid::Actor[:health_metric].inc_http_404s
        end
      end
    end
  end
end
