require "active_record"

module AppStatus
  class Database
    def ok?
      response = begin
                   ActiveRecord::Base.connection_pool.with_connection do |connection|
                     raw_db_response = connection.execute("SELECT VERSION() AS version").first

                     # Handle differences in JDBC and mysql2 drivers...
                     version = raw_db_response.is_a?(Hash) ? raw_db_response["version"] : raw_db_response.first

                     !!(version =~ /\A5.+/)
                   end
                 rescue StandardError => e
                   Logger.error("[AppStatus] Database connection check yielded error (#{e.message})")
                   Logger.debug("[AppStatus] Backtrace: \n #{e.backtrace.join("\n")}")

                   false
                 end

      Logger.debug("[AppStatus] Database connection status is #{response}")

      response
    end
  end
end
