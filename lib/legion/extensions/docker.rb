# frozen_string_literal: true

require 'legion/extensions/docker/version'
require 'legion/extensions/docker/helpers/client'
require 'legion/extensions/docker/runners/containers'
require 'legion/extensions/docker/runners/images'
require 'legion/extensions/docker/runners/networks'
require 'legion/extensions/docker/client'

module Legion
  module Extensions
    module Docker
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
