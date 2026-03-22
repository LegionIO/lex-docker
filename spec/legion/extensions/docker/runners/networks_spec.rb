# frozen_string_literal: true

RSpec.describe Legion::Extensions::Docker::Runners::Networks do
  subject(:client) { Legion::Extensions::Docker::Client.new }

  before { allow(client).to receive(:connection) }

  describe '#list_networks' do
    it 'returns an array of network info hashes' do
      fake_network = instance_double(Docker::Network, info: { 'Id' => 'net123', 'Name' => 'bridge' })
      allow(Docker::Network).to receive(:all).and_return([fake_network])
      result = client.list_networks
      expect(result).to be_an(Array)
      expect(result.first['Name']).to eq('bridge')
    end
  end

  describe '#create_network' do
    it 'creates a network and returns its info' do
      fake_network = instance_double(Docker::Network, info: { 'Id' => 'net456', 'Name' => 'mynet' })
      allow(Docker::Network).to receive(:create).with('mynet', { 'Name' => 'mynet', 'Driver' => 'bridge' }).and_return(fake_network)
      result = client.create_network(name: 'mynet')
      expect(result[:network]['Name']).to eq('mynet')
    end

    it 'uses the specified driver' do
      fake_network = instance_double(Docker::Network, info: { 'Id' => 'net789', 'Name' => 'overlay-net' })
      allow(Docker::Network).to receive(:create).with('overlay-net',
                                                      { 'Name'   => 'overlay-net',
                                                        'Driver' => 'overlay' }).and_return(fake_network)
      result = client.create_network(name: 'overlay-net', driver: 'overlay')
      expect(result[:network]['Id']).to eq('net789')
    end
  end
end
