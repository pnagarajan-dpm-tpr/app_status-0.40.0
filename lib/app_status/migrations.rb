require 'active_record'

module AppStatus
  class Migrations
    def ok?
      response = begin
                   has_pending_migrations?
                 rescue StandardError => e
                   Logger.error("[AppStatus] Migrations check yielded error (#{e.message})")
                   Logger.debug("[AppStatus] Backtrace: \n #{e.backtrace.join("\n")}")

                   false
                 end

      Logger.debug("[AppStatus] Migrations status is #{response}")

      response
    end

    private

    def has_pending_migrations?
      ActiveRecord::Base.connection_pool.with_connection do |connection|
        if ActiveRecord::Migrator.respond_to?(:needs_migration?)
          !ActiveRecord::Migrator.needs_migration?
        else
          ActiveRecord::Migrator.new(
            :up, ActiveRecord::Migrator.migrations_paths
          ).pending_migrations.empty?
        end
      end
    end
  end
end
