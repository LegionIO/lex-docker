# Changelog

## [0.1.0] - 2026-03-22

### Added
- Initial release
- `Helpers::Client` — Docker API connection wrapper with configurable URL and timeouts
- `Runners::Containers` — list_containers, create_container, start_container, stop_container, remove_container, container_logs
- `Runners::Images` — list_images, pull_image, build_image, remove_image
- `Runners::Networks` — list_networks, create_network
- Standalone `Client` class for use outside the Legion framework
