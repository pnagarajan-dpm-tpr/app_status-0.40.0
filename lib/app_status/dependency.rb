require "faraday"

module AppStatus
  UnsupportedHttpMethod = Class.new(StandardError)

  class Dependency
    SUPPORTED_HTTP_METHODS = [:get, :head]

    def initialize(base_url, options = {})
      self.url             = base_url
      self.status_path     = options.fetch(:status_path, 'status')
      self.http_method     = options.fetch(:http_method, :head)
      self.timeout         = options.fetch(:timeout, 10)
      self.open_timeout    = options.fetch(:open_timeout, 5)
      self.expected_status = options.fetch(:expected_status, 200)

      unless valid_http_method?
        raise UnsupportedHttpMethod.new('You can use only :get or :head HTTP method')
      end
    end

    def ok?
      response = begin
                   connection.send(http_method, status_path) do |req|
                     req.options[:timeout]      = timeout
                     req.options[:open_timeout] = open_timeout
                   end.status == expected_status
                 rescue StandardError => e
                   Logger.error("[AppStatus] Dependency (#{url.to_s}) check yielded error (#{e.message})")
                   Logger.debug("[AppStatus] Backtrace: \n #{e.backtrace.join("\n")}")

                   false
                 end

      Logger.debug("[AppStatus] Dependency (#{url.to_s}) status is #{response}")

      response
    end

    private

    attr_accessor :url, :status_path, :http_method,
      :timeout, :open_timeout, :expected_status

    def connection
      Faraday.new(url: url, ssl: ssl_options)
    end

    def ssl_options
      if defined?(AppConfig) && AppConfig.respond_to?(:ssl_options)
        AppConfig.ssl_options
      else
        {}
      end
    end

    def valid_http_method?
      SUPPORTED_HTTP_METHODS.include? http_method
    end
  end
end
