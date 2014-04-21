module Sidekiq
  module Logging
    module GELF
      class Formatter < Logger::Formatter
        def call(severity, time, facility, message)
          message.merge({
            pid: Process.pid,
            tid: Thread.current.object_id.to_s(36),
            context: Thread.current[:sidekiq_context]
          })
        end
      end
    end
  end
end