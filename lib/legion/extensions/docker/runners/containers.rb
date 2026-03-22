# frozen_string_literal: true

module Legion
  module Extensions
    module Docker
      module Runners
        module Containers
          def list_containers(**opts)
            conn = opts.delete(:connection)
            connection(**opts) unless conn
            ::Docker::Container.all(all: opts.fetch(:all, false))&.map(&:info)
          end

          def create_container(**opts)
            conn = opts.delete(:connection)
            connection(**opts) unless conn
            image  = opts.fetch(:image)
            name   = opts[:name]
            cmd    = opts[:cmd]
            env    = opts[:env]
            config = { 'Image' => image }
            config['name'] = name if name
            config['Cmd']  = cmd if cmd
            config['Env']  = env if env
            container = ::Docker::Container.create(config)
            { container: container.info }
          end

          def start_container(**opts)
            conn = opts.delete(:connection)
            connection(**opts) unless conn
            container_id = opts.fetch(:container_id)
            container = ::Docker::Container.get(container_id)
            container.start
            { started: true, container_id: container_id }
          end

          def stop_container(**opts)
            conn = opts.delete(:connection)
            connection(**opts) unless conn
            container_id = opts.fetch(:container_id)
            timeout      = opts.fetch(:timeout, 10)
            container = ::Docker::Container.get(container_id)
            container.stop(t: timeout)
            { stopped: true, container_id: container_id }
          end

          def remove_container(**opts)
            conn = opts.delete(:connection)
            connection(**opts) unless conn
            container_id = opts.fetch(:container_id)
            force        = opts.fetch(:force, false)
            container = ::Docker::Container.get(container_id)
            container.remove(force: force)
            { removed: true, container_id: container_id }
          end

          def container_logs(**opts)
            conn = opts.delete(:connection)
            connection(**opts) unless conn
            container_id = opts.fetch(:container_id)
            tail         = opts.fetch(:tail, 'all')
            timestamps   = opts.fetch(:timestamps, false)
            container = ::Docker::Container.get(container_id)
            logs = container.logs(stdout: true, stderr: true, tail: tail, timestamps: timestamps)
            { logs: logs, container_id: container_id }
          end
        end
      end
    end
  end
end
