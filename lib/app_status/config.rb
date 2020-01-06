module AppStatus
  class Config
    def health_metric_enabled
      return true unless defined?(@health_metric_enabled)

      @health_metric_enabled
    end

    attr_writer :health_metric_enabled
  end
end
