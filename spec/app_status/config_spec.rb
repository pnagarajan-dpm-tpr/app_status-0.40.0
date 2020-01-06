require 'spec_helper'

describe 'AppStatus::Config' do
  describe 'health metric' do
    it 'can be disabled' do
      AppStatus.configure do |config|
        config.health_metric_enabled = false
      end

      expect(AppStatus.health_metric_enabled).to eq(false)
    end
  end
end
