# frozen_string_literal: true

module Legion
  module Extensions
    module Docker
      module Runners
        module Images
          def list_images(**opts)
            conn = opts.delete(:connection)
            connection(**opts) unless conn
            ::Docker::Image.all&.map(&:info)
          end

          def pull_image(**opts)
            conn = opts.delete(:connection)
            connection(**opts) unless conn
            repo = opts.fetch(:repo)
            tag  = opts.fetch(:tag, 'latest')
            image = ::Docker::Image.create('fromImage' => repo, 'tag' => tag)
            { image: image.info }
          end

          def build_image(**opts)
            conn = opts.delete(:connection)
            connection(**opts) unless conn
            dir = opts.fetch(:dir)
            t   = opts[:tag]
            build_opts = {}
            build_opts['t'] = t if t
            image = ::Docker::Image.build_from_dir(dir, build_opts)
            { image: image.info }
          end

          def remove_image(**opts)
            conn = opts.delete(:connection)
            connection(**opts) unless conn
            image_id = opts.fetch(:image_id)
            force    = opts.fetch(:force, false)
            image = ::Docker::Image.get(image_id)
            image.remove(force: force)
            { removed: true, image_id: image_id }
          end
        end
      end
    end
  end
end
