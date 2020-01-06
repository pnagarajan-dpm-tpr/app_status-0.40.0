require 'spec_helper'

describe AppStatus::ClusterDependency do
  let(:urls) { ['http://ep1.local.dev', 'http://ep2.local.dev'] }
  let(:result) { described_class.new(urls).status }

  before do
    FakeWeb.register_uri(:head, "#{urls.first}/status", body: '', status: ['200', 'OK'])
    FakeWeb.register_uri(:head, "#{urls.last}/status", body: '', status: ['500', 'Internal Server Error'])
  end

  it 'returns hash' do
    expect(result).to be_kind_of(Hash)
  end

  it 'checks every dependency' do
    expect(result.keys.sort).to eql urls.sort
  end

  it 'returns dependency status' do
    expect(result[urls.first]).to eq true
    expect(result[urls.last]).to eq false
  end
end
