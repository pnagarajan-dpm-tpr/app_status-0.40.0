require "celluloid"

module AppStatus
  class HealthMetric
    include Celluloid
    include Celluloid::Logger

    attr_reader :failed_mobile_api_logins, :last_failed_mobile_api_login,
      :http_404s, :last_http_404, :processed_transactions,
      :last_processed_transaction, :failed_was_calls, :last_failed_was_call,
      :published_transactions, :last_published_transaction, :failed_transactions,
      :last_failed_transaction, :elasticsearch_404s, :last_elasticsearch_404

    def initialize
      info "Starting HealthMetric agent"

      self.failed_mobile_api_logins = 0
      self.http_404s                = 0
      self.processed_transactions   = 0
      self.failed_was_calls         = 0
      self.published_transactions   = 0
      self.failed_transactions      = 0
      self.elasticsearch_404s       = 0
    end

    def inc_failed_mobile_api_logins
      self.failed_mobile_api_logins     = failed_mobile_api_logins + 1
      self.last_failed_mobile_api_login = DateTime.now
    end

    def inc_http_404s
      self.http_404s     = http_404s + 1
      self.last_http_404 = DateTime.now
    end

    def inc_processed_transactions
      self.processed_transactions     = processed_transactions + 1
      self.last_processed_transaction = DateTime.now
    end

    def inc_failed_was_calls
      self.failed_was_calls     = failed_was_calls + 1
      self.last_failed_was_call = DateTime.now
    end

    def inc_published_transactions
      self.published_transactions     = published_transactions + 1
      self.last_published_transaction = DateTime.now
    end

    def inc_failed_transactions
      self.failed_transactions     = failed_transactions + 1
      self.last_failed_transaction = DateTime.now
    end

    def inc_elasticsearch_404s
      self.elasticsearch_404s     = elasticsearch_404s + 1
      self.last_elasticsearch_404 = DateTime.now
    end

    private

    attr_writer :failed_mobile_api_logins, :last_failed_mobile_api_login,
      :http_404s, :last_http_404, :processed_transactions,
      :last_processed_transaction, :failed_was_calls, :last_failed_was_call,
      :published_transactions, :last_published_transaction, :failed_transactions,
      :last_failed_transaction, :elasticsearch_404s, :last_elasticsearch_404
  end
end

