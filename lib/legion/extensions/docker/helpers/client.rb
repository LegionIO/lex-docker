# frozen_string_literal: true

require 'docker-api'

module Legion
  module Extensions
    module Docker
      module Helpers
        module Client
          module_function

          def connection(**opts)
            url = opts[:docker_url] || settings_value(:docker_url, 'unix:///var/run/docker.sock')
            ::Docker.url = url
            ::Docker.options = {
              read_timeout:  opts.fetch(:read_timeout, 120),
              write_timeout: opts.fetch(:write_timeout, 120)
            }
            ::Docker
          end

          def settings_value(key, default)
            return default unless defined?(Legion::Settings)

            settings = Legion::Settings[:'lex-docker']
            settings.is_a?(Hash) ? settings.fetch(key, default) : default
          end
        end
      end
    end
  end
end
