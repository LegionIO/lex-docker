# lex-docker: Docker Integration for LegionIO

**Repository Level 3 Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-other/CLAUDE.md`
- **Grandparent**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Legion Extension that connects LegionIO to the Docker daemon via the `docker-api` gem. Provides runners for container lifecycle management, image operations, and network management.

**GitHub**: https://github.com/LegionIO/lex-docker
**License**: MIT
**Version**: 0.1.2

## Architecture

```
Legion::Extensions::Docker
├── Runners/
│   ├── Containers  # list_containers, create_container, start_container, stop_container, remove_container, container_logs
│   ├── Images      # list_images, pull_image, build_image, remove_image
│   └── Networks    # list_networks, create_network
├── Helpers/
│   └── Client      # Docker daemon connection factory (configurable URL and timeouts)
└── Client          # Standalone client class (includes all runners)
```

## Key Files

| Path | Purpose |
|------|---------|
| `lib/legion/extensions/docker.rb` | Entry point, extension registration |
| `lib/legion/extensions/docker/runners/containers.rb` | Container lifecycle: list, create, start, stop, remove, logs |
| `lib/legion/extensions/docker/runners/images.rb` | Image ops: list, pull, build, remove |
| `lib/legion/extensions/docker/runners/networks.rb` | Network ops: list, create |
| `lib/legion/extensions/docker/helpers/client.rb` | `connection(**opts)` — sets `Docker.url` and `Docker.options` |
| `lib/legion/extensions/docker/client.rb` | Standalone `Client` class |

## Runner Methods

**Containers**

| Method | Parameters | Description |
|--------|-----------|-------------|
| `list_containers` | `all: false` | List running (or all) containers |
| `create_container` | `image:`, `name:`, `cmd:`, `env:` | Create a container |
| `start_container` | `container_id:` | Start a container |
| `stop_container` | `container_id:`, `timeout: 10` | Stop a container |
| `remove_container` | `container_id:`, `force: false` | Remove a container |
| `container_logs` | `container_id:`, `tail: 'all'`, `timestamps: false` | Fetch container logs |

**Images**

| Method | Parameters | Description |
|--------|-----------|-------------|
| `list_images` | — | List all images |
| `pull_image` | `repo:`, `tag: 'latest'` | Pull an image |
| `build_image` | `dir:`, `tag:` | Build image from directory |
| `remove_image` | `image_id:`, `force: false` | Remove an image |

**Networks**

| Method | Parameters | Description |
|--------|-----------|-------------|
| `list_networks` | — | List all networks |
| `create_network` | `name:`, `driver: 'bridge'` | Create a network |

## Connection

`Helpers::Client#connection` sets `Docker.url` (default: `unix:///var/run/docker.sock`) and configures `read_timeout`/`write_timeout` (default: 120s). Settings can be overridden via `Legion::Settings[:'lex-docker'][:docker_url]`.

## Dependencies

| Gem | Purpose |
|-----|---------|
| `docker-api` (~> 2.0) | Docker Remote API client |
| `base64` | Required by docker-api for auth encoding |

## Development

19 specs total.

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

---

**Maintained By**: Matthew Iverson (@Esity)
