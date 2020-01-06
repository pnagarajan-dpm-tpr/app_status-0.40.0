require 'spec_helper'

describe AppStatus::Dependency do
  let(:url) { 'http://local.dev' }

  before do
    FakeWeb.register_uri(:head, "#{url}/app_status_200",   body: '200', status: ['200', 'OK'])
    FakeWeb.register_uri(:head, "#{url}/app_status_300",   body: '300', status: ['300', 'OK'])
    FakeWeb.register_uri(:head, "#{url}/foobar",           body: 'foobar', status: ['300', 'OK'])
    FakeWeb.register_uri(:head, "#{url}/container/foobar", body: 'foobar', status: ['300', 'OK'])
    FakeWeb.register_uri(:head, "#{url}/foo/bar",          body: 'foobar', status: ['300', 'OK'])
    FakeWeb.register_uri(:head, "#{url}/timeout",          exception: Timeout::Error)
  end

  describe 'expected status' do
    it 'should be 200 by default' do
      status = described_class.new(url, status_path: 'app_status_200')

      expect(status).to be_ok
    end

    it 'should not accept any other status' do
      status = described_class.new(url, status_path: 'app_status_300')

      expect(status).to_not be_ok
    end

    it 'should allow changing expected status' do
      status = described_class.new(url, status_path: 'app_status_300', expected_status: 300)

      expect(status).to be_ok
    end
  end

  describe 'request method' do
    it 'should be set to head by default' do
      status = described_class.new(url)

      expect(status.send(:http_method)).to eq(:head)
    end

    it 'get should be also allowed' do
      expect {
        described_class.new(url, http_method: :get)
      }.to_not raise_error
    end

    it 'should raise error for any other http method' do
      expect {
        described_class.new(url, http_method: :post)
      }.to raise_error

      expect {
        described_class.new(url, http_method: :put)
      }.to raise_error
    end
  end

  describe 'status path' do
    it 'should be configurable' do
      status = described_class.new(url, status_path: '/foobar')

      status.ok?

      expect(
        FakeWeb.last_request.path
      ).to eq('/foobar')
    end

    context 'when base_url contains non-empty path' do
      let(:url) { 'http://local.dev/container' }

      it 'is preserved when status_path is relative' do
        status = described_class.new(url, status_path: 'foobar')

        status.ok?

        expect(
          FakeWeb.last_request.path
        ).to eq('/container/foobar')
      end

      it 'is not preserved when status_path is not relative' do
        status = described_class.new(url, status_path: '/foobar')

        status.ok?

        expect(
          FakeWeb.last_request.path
        ).to eq('/foobar')
      end
    end
  end

  describe 'timeout' do
    it 'should return false' do
      status = described_class.new("#{url}/timeout")

      expect(status).to_not be_ok
    end
  end
end
