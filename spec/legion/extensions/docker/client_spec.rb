# frozen_string_literal: true

RSpec.describe Legion::Extensions::Docker::Client do
  subject(:client) { described_class.new(docker_url: 'unix:///var/run/docker.sock') }

  describe '#initialize' do
    it 'stores opts' do
      expect(client.opts[:docker_url]).to eq('unix:///var/run/docker.sock')
    end
  end

  describe '#settings' do
    it 'returns a hash with options key' do
      expect(client.settings).to eq({ options: client.opts })
    end
  end

  describe '#connection' do
    it 'returns the Docker module' do
      expect(client.connection).to eq(Docker)
    end
  end
end
