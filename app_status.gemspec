# encoding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "app_status"
  spec.version       = "0.40.0"
  spec.authors       = ["Upnext Ltd."]
  spec.email         = ["backend-dev@up-next.com"]
  spec.description   = %q{AppStatus}
  spec.summary       = %q{AppStatus}
  spec.homepage      = ""

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord"
  spec.add_dependency "celluloid"
  spec.add_dependency "faraday"
  spec.add_dependency "multi_json"
  spec.add_dependency "stomp"
  spec.add_dependency "tire"

  if RUBY_PLATFORM =~ /java/
    spec.add_dependency 'jruby-memcached'
  else
    spec.add_dependency 'memcached'
  end

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "fakeweb"
  spec.add_development_dependency "pry"
end
