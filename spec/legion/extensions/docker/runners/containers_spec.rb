# frozen_string_literal: true

RSpec.describe Legion::Extensions::Docker::Runners::Containers do
  subject(:client) { Legion::Extensions::Docker::Client.new }

  before { allow(client).to receive(:connection) }

  describe '#list_containers' do
    it 'returns an array of container info hashes' do
      fake_container = instance_double(Docker::Container, info: { 'Id' => 'abc123', 'Names' => ['/web'] })
      allow(Docker::Container).to receive(:all).with(all: false).and_return([fake_container])
      result = client.list_containers
      expect(result).to be_an(Array)
      expect(result.first['Id']).to eq('abc123')
    end

    it 'passes all: true when requested' do
      allow(Docker::Container).to receive(:all).with(all: true).and_return([])
      result = client.list_containers(all: true)
      expect(result).to eq([])
    end
  end

  describe '#create_container' do
    it 'creates a container and returns its info' do
      fake_container = instance_double(Docker::Container, info: { 'Id' => 'def456' })
      allow(Docker::Container).to receive(:create).with({ 'Image' => 'nginx' }).and_return(fake_container)
      result = client.create_container(image: 'nginx')
      expect(result[:container]['Id']).to eq('def456')
    end

    it 'includes name and cmd when provided' do
      fake_container = instance_double(Docker::Container, info: { 'Id' => 'ghi789' })
      expected_config = { 'Image' => 'alpine', 'name' => 'myapp', 'Cmd' => ['sh', '-c', 'echo hi'] }
      allow(Docker::Container).to receive(:create).with(expected_config).and_return(fake_container)
      result = client.create_container(image: 'alpine', name: 'myapp', cmd: ['sh', '-c', 'echo hi'])
      expect(result[:container]['Id']).to eq('ghi789')
    end
  end

  describe '#start_container' do
    it 'starts a container and returns success' do
      fake_container = instance_double(Docker::Container)
      allow(Docker::Container).to receive(:get).with('abc123').and_return(fake_container)
      allow(fake_container).to receive(:start)
      result = client.start_container(container_id: 'abc123')
      expect(result[:started]).to be true
      expect(result[:container_id]).to eq('abc123')
    end
  end

  describe '#stop_container' do
    it 'stops a container and returns success' do
      fake_container = instance_double(Docker::Container)
      allow(Docker::Container).to receive(:get).with('abc123').and_return(fake_container)
      allow(fake_container).to receive(:stop).with(t: 10)
      result = client.stop_container(container_id: 'abc123')
      expect(result[:stopped]).to be true
      expect(result[:container_id]).to eq('abc123')
    end
  end

  describe '#remove_container' do
    it 'removes a container and returns success' do
      fake_container = instance_double(Docker::Container)
      allow(Docker::Container).to receive(:get).with('abc123').and_return(fake_container)
      allow(fake_container).to receive(:remove).with(force: false)
      result = client.remove_container(container_id: 'abc123')
      expect(result[:removed]).to be true
      expect(result[:container_id]).to eq('abc123')
    end
  end

  describe '#container_logs' do
    it 'returns logs for the container' do
      fake_container = instance_double(Docker::Container)
      allow(Docker::Container).to receive(:get).with('abc123').and_return(fake_container)
      allow(fake_container).to receive(:logs).with(stdout: true, stderr: true, tail: 'all',
                                                   timestamps: false).and_return('log output')
      result = client.container_logs(container_id: 'abc123')
      expect(result[:logs]).to eq('log output')
      expect(result[:container_id]).to eq('abc123')
    end
  end
end
