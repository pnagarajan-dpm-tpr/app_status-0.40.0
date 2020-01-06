module AppStatus
  class StatusProxy
    def initialize(configured_checks, other_stats)
      self.configured_checks = configured_checks
      self.other_stats = other_stats
    end

    def add_class(klass, options = {}, &block)
      configured_checks[options[:name].to_sym] = Proc.new do
        klass.new(*options[:args], &block).ok?
      end
    end

    def add_object(name, object)
      configured_checks[name.to_sym] = Proc.new do
        object.ok?
      end
    end

    def add_block(name, &block)
      configured_checks[name.to_sym] = block
    end

    def add_other_stat(name, &block)
      other_stats[name.to_sym] = block
    end

    private

    attr_accessor :configured_checks, :other_stats
  end

  class RackApp
    def initialize(options = {}, &block)
      self.configured_checks = {}
      self.other_stats = {}

      yield StatusProxy.new(configured_checks, other_stats)
    end

    def call(env)
      output = configured_checks.each_with_object({}) do |(name, check), outcome|
        outcome[name] = check.call
      end

      output[:overall_ok?] = output.values.all?

      other_stats.each do |name, stat|
        output[name] = stat.call
      end

      [200, headers, [format_response(output)]]
    end

    private

    def headers
      {'Content-Type' => 'application/json'}
    end

    def format_response(output)
      MultiJson.dump(output)
    end

    attr_accessor :configured_checks, :other_stats
  end
end
