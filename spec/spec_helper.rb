require 'bundler/setup'
Bundler.setup

require 'app_status' # and any other gems you need
require 'fakeweb'

FakeWeb.allow_net_connect = false

RSpec.configure do |config|

  config.before(:each) do
    allow(Logger).to receive(:error)
    allow(Logger).to receive(:debug)
  end
end
