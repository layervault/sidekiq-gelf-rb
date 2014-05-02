require 'logger'
require 'gelf'
require 'sidekiq'

require 'sidekiq-gelf/middleware'

module Sidekiq
  module Logging
    module GELF
      extend self

      def hook!(*args)
        Sidekiq.configure_server do |config|
          config.server_middleware do |chain|
            chain.add Middleware::Server::GELFLogging, *args
          end
        end
      end
    end
  end
end