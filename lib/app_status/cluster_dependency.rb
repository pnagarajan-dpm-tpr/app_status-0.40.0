module AppStatus
  class ClusterDependency
    def initialize(urls, options = {})
      self.urls    = urls
      self.options = options
    end

    def status
      urls.inject({}) do |hash, url|
        hash[url] = Dependency.new(url, options).ok?
        hash
      end
    end

    private

    attr_accessor :urls, :options
  end
end
