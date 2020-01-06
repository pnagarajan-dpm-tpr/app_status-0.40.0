require "multi_json"
require "tire"

module AppStatus
  class Elasticsearch
    def initialize(elasticsearch_endpoint)
      self.elasticsearch_endpoint = elasticsearch_endpoint
    end

    def ok?
      response = begin
                   Tire::Configuration.client.head(elasticsearch_endpoint).code == 200
                 rescue StandardError => e
                   Logger.error("[AppStatus] ElasticSearch check yielded error (#{e.message})")
                   Logger.debug("[AppStatus] Backtrace: \n #{e.backtrace.join("\n")}")

                   false
                 end
      Logger.debug("[AppStatus] ElasticSearch status is #{response}")

      response
    end

    private

    attr_accessor :elasticsearch_endpoint
  end
end
