# frozen_string_literal: true

require_relative 'helpers/client'
require_relative 'runners/containers'
require_relative 'runners/images'
require_relative 'runners/networks'

module Legion
  module Extensions
    module Docker
      class Client
        include Helpers::Client
        include Runners::Containers
        include Runners::Images
        include Runners::Networks

        attr_reader :opts

        def initialize(**opts)
          @opts = opts
        end

        def settings
          { options: @opts }
        end

        def connection(**override)
          super(**@opts, **override)
        end
      end
    end
  end
end
