# frozen_string_literal: true

RSpec.describe Legion::Extensions::Docker::Runners::Images do
  subject(:client) { Legion::Extensions::Docker::Client.new }

  before { allow(client).to receive(:connection) }

  describe '#list_images' do
    it 'returns an array of image info hashes' do
      fake_image = instance_double(Docker::Image, info: { 'Id' => 'sha256:abc', 'RepoTags' => ['nginx:latest'] })
      allow(Docker::Image).to receive(:all).and_return([fake_image])
      result = client.list_images
      expect(result).to be_an(Array)
      expect(result.first['Id']).to eq('sha256:abc')
    end
  end

  describe '#pull_image' do
    it 'pulls an image and returns its info' do
      fake_image = instance_double(Docker::Image, info: { 'Id' => 'sha256:def' })
      allow(Docker::Image).to receive(:create).with('fromImage' => 'nginx', 'tag' => 'latest').and_return(fake_image)
      result = client.pull_image(repo: 'nginx')
      expect(result[:image]['Id']).to eq('sha256:def')
    end

    it 'uses the specified tag' do
      fake_image = instance_double(Docker::Image, info: { 'Id' => 'sha256:ghi' })
      allow(Docker::Image).to receive(:create).with('fromImage' => 'nginx', 'tag' => '1.25').and_return(fake_image)
      result = client.pull_image(repo: 'nginx', tag: '1.25')
      expect(result[:image]['Id']).to eq('sha256:ghi')
    end
  end

  describe '#build_image' do
    it 'builds an image from a directory and returns its info' do
      fake_image = instance_double(Docker::Image, info: { 'Id' => 'sha256:jkl' })
      allow(Docker::Image).to receive(:build_from_dir).with('/app', { 't' => 'myapp:latest' }).and_return(fake_image)
      result = client.build_image(dir: '/app', tag: 'myapp:latest')
      expect(result[:image]['Id']).to eq('sha256:jkl')
    end
  end

  describe '#remove_image' do
    it 'removes an image and returns success' do
      fake_image = instance_double(Docker::Image)
      allow(Docker::Image).to receive(:get).with('sha256:abc').and_return(fake_image)
      allow(fake_image).to receive(:remove).with(force: false)
      result = client.remove_image(image_id: 'sha256:abc')
      expect(result[:removed]).to be true
      expect(result[:image_id]).to eq('sha256:abc')
    end
  end
end
