require "stomp"

module AppStatus
  class Activemq
    def initialize(stomp_endpoints)
      self.stomp_endpoints = stomp_endpoints
    end

    def ok?
      response = begin
                   stomp_connection.open?
                 rescue StandardError, RuntimeError => e
                   Logger.error("[AppStatus] ActiveMq check yielded error (#{e.message})")
                   Logger.debug("[AppStatus] Backtrace: \n #{e.backtrace.join("\n")}")

                   false
                 ensure
                   stomp_connection.close
                 end

      Logger.debug("[AppStatus] ActiveMq status is #{response}")

      response
    end

    private

    attr_accessor :stomp_endpoints

    def stomp_connection
      @stomp_connection ||= Stomp::Client.new(
        hosts: stomp_endpoints, max_reconnect_attempts: stomp_endpoints.size - 1, reliable: true
      )
    end
  end
end
