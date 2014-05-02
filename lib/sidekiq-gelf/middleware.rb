module Sidekiq
  module Middleware
    module Server
      class GELFLogging
        def initialize(*args)
          @args = *args
        end

        def call(worker, item, queue)
          Sidekiq::Logging.with_context("#{worker.class.to_s} JID-#{item['jid']}") do
            begin
              logger.info({
                short_message: "Start: #{worker.class.to_s} JID-#{item['jid']}",
                pid: pid,
                tid: tid,
                context: context,
                worker: worker.class.to_s,
                queue: queue,
                params: item['args']
              })

              start = Time.now

              yield # Pass the torch

              logger.info({
                short_message: "Done: #{worker.class.to_s} JID-#{item['jid']}",
                pid: pid,
                tid: tid,
                context: context,
                worker: worker.class.to_s,
                queue: queue,
                params: item['args'],
                runtime: elapsed(start)
              })
            rescue Exception => e
              logger.error({
                short_message: "Fail: #{worker.class.to_s} JID-#{item['jid']}",
                pid: pid,
                tid: tid,
                context: context,
                worker: worker.class.to_s,
                queue: queue,
                params: item['args'],
                runtime: elapsed(start),
                exception_class: e.class.to_s,
                exception_message: e.message,
                backtrace: e.backtrace.join("\n")
              })

              raise e
            end
          end
        end

        def logger
          @logger ||= ::GELF::Logger.new(*@args)
        end

        private

        def pid
          Process.pid
        end

        def tid
          Thread.current.object_id.to_s(36)
        end

        def context
          Thread.current[:sidekiq_context]
        end

        def elapsed(start)
          (Time.now - start).to_f.round(3)
        end
      end
    end
  end
end