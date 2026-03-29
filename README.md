# lex-docker

Docker integration for [LegionIO](https://github.com/LegionIO/LegionIO). Manage containers, images, and networks from within Legion task chains or as a standalone client library.

## Installation

```bash
gem install lex-docker
```

Or add to your Gemfile:

```ruby
gem 'lex-docker'
```

## Standalone Usage

```ruby
require 'legion/extensions/docker'

client = Legion::Extensions::Docker::Client.new(
  docker_url: 'unix:///var/run/docker.sock'  # default
)

# Containers
client.list_containers
client.list_containers(all: true)
client.create_container(image: 'nginx:latest', name: 'web')
client.start_container(container_id: 'abc123')
client.stop_container(container_id: 'abc123', timeout: 30)
client.container_logs(container_id: 'abc123', tail: 100)
client.remove_container(container_id: 'abc123', force: true)

# Images
client.list_images
client.pull_image(repo: 'nginx', tag: 'latest')
client.build_image(dir: '/path/to/context', tag: 'myapp:v1')
client.remove_image(image_id: 'sha256:...')

# Networks
client.list_networks
client.create_network(name: 'my-net', driver: 'bridge')
```

## Runners

### Containers

| Method | Parameters | Description |
|--------|-----------|-------------|
| `list_containers` | `all: false` | List running (or all) containers |
| `create_container` | `image:`, `name:`, `cmd:`, `env:` | Create a container |
| `start_container` | `container_id:` | Start a container |
| `stop_container` | `container_id:`, `timeout: 10` | Stop a container |
| `remove_container` | `container_id:`, `force: false` | Remove a container |
| `container_logs` | `container_id:`, `tail: 'all'`, `timestamps: false` | Fetch container logs |

### Images

| Method | Parameters | Description |
|--------|-----------|-------------|
| `list_images` | — | List all images |
| `pull_image` | `repo:`, `tag: 'latest'` | Pull an image from a registry |
| `build_image` | `dir:`, `tag:` | Build an image from a directory |
| `remove_image` | `image_id:`, `force: false` | Remove an image |

### Networks

| Method | Parameters | Description |
|--------|-----------|-------------|
| `list_networks` | — | List all networks |
| `create_network` | `name:`, `driver: 'bridge'` | Create a network |

## Configuration

The Docker daemon URL defaults to `unix:///var/run/docker.sock`. Override via `docker_url:` kwarg or Legion settings:

```json
{
  "lex-docker": {
    "docker_url": "tcp://docker-host:2376"
  }
}
```

## Requirements

- Ruby >= 3.4
- Docker daemon accessible at the configured URL
- `docker-api` ~> 2.0

## License

MIT
