require "faraday"

module AppStatus
  class Was
    def initialize(url, ref_id, username, password, options = {})
      self.url          = url
      self.ref_id       = ref_id
      self.username     = username
      self.password     = password
      self.timeout      = options.fetch(:timeout, 10)
      self.open_timeout = options.fetch(:open_timeout, 5)
    end

    def ok?
      response = begin
                   Faraday::Connection.new(
                     url: url, ssl: ssl_options
                   ).tap do |connection|
                     connection.basic_auth(username, password)
                     connection.options[:timeout]      = timeout
                     connection.options[:open_timeout] = open_timeout
                   end.get("/was/business-portal/rest-api/v1/#{ref_id}/ping").status == 200
                 rescue StandardError => e
                   Logger.error("[AppStatus] WAS check yielded error (#{e.message})")
                   Logger.debug("[AppStatus] Backtrace: \n #{e.backtrace.join("\n")}")

                   false
                 end

      Logger.debug("[AppStatus] WAS status is #{response}")

      response
    end

    private

    attr_accessor :url, :ref_id, :username, :password, :timeout, :open_timeout

    def ssl_options
      if defined?(AppConfig) && AppConfig.respond_to?(:ssl_options)
        AppConfig.ssl_options
      else
        {}
      end
    end
  end
end
