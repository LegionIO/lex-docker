# frozen_string_literal: true

module Legion
  module Extensions
    module Docker
      module Runners
        module Networks
          def list_networks(**opts)
            conn = opts.delete(:connection)
            connection(**opts) unless conn
            ::Docker::Network.all&.map(&:info)
          end

          def create_network(**opts)
            conn = opts.delete(:connection)
            connection(**opts) unless conn
            name   = opts.fetch(:name)
            driver = opts.fetch(:driver, 'bridge')
            config = { 'Name' => name, 'Driver' => driver }
            network = ::Docker::Network.create(name, config)
            { network: network.info }
          end
        end
      end
    end
  end
end
