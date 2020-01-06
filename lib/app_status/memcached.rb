require 'memcached'

module AppStatus
  class Memcached
    def initialize(memcached_hosts)
      @memcached_connection = ::Memcached::Rails.new(memcached_hosts)
    end

    def ok?
      response = begin
                   @memcached_connection.stats
                   @memcached_connection.active?
                 rescue StandardError => e
                   Logger.error("[AppStatus] Memcached check yielded error (#{e.message})")
                   Logger.debug("[AppStatus] Backtrace: \n #{e.backtrace.join("\n")}")

                   false
                 ensure
                   @memcached_connection.shutdown
                 end

      Logger.debug("[AppStatus] Memcached status is #{response}")

      response
    end
  end
end
