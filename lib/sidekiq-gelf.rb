require 'logger'
require 'gelf'
require 'sidekiq'

require 'sidekiq-gelf/formatter'

module Sidekiq
  module Logging
    module GELF
      extend self

      def hook!(*args)
        Sidekiq::Logging.logger = ::GELF::Logger.new(*args)
        Sidekiq::Logging.logger.formatter = Formatter.new
      end
    end
  end
end