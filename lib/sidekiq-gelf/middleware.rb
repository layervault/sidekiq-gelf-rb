module Sidekiq
  module Middleware
    module Server
      class GELFLogging
        def initialize(*args)
          @args = *args
        end

        def call(worker, item, queue)
          Sidekiq::Context.with(worker: worker, item: item, queue: queue) do
            logger.info(filter_fields(short_message: "Sidekiq start: #{worker.class.to_s} JID-#{item['jid']}",
                                      jid: item['jid'],
                                      pid: pid,
                                      tid: tid,
                                      context: context,
                                      worker: worker.class.to_s,
                                      queue: queue,
                                      params: item['args'],
                                      latency: Sidekiq::Queue.new(queue).latency,
                                      memory: memory))

            start = Time.current

            yield # Pass the torch

            logger.info(filter_fields(short_message: "Sidekiq done: #{worker.class.to_s} JID-#{item['jid']}",
                                      jid: item['jid'],
                                      pid: pid,
                                      tid: tid,
                                      context: context,
                                      worker: worker.class.to_s,
                                      queue: queue,
                                      params: item['args'],
                                      runtime: elapsed(start),
                                      memory: memory))
          rescue StandardError => e
            logger.error(filter_fields(short_message: "Sidekiq fail: #{worker.class.to_s} JID-#{item['jid']}",
                                       jid: item['jid'],
                                       pid: pid,
                                       tid: tid,
                                       context: context,
                                       worker: worker.class.to_s,
                                       queue: queue,
                                       params: item['args'],
                                       runtime: elapsed(start),
                                       exception_class: e.class.to_s,
                                       exception_message: e.message,
                                       backtrace: e.backtrace.join("\n"),
                                       memory: memory))

            raise e
          end
        end

        def logger
          Thread.current[:sidekiq_gelf_logger] ||= ::GELF::Logger.new(*@args)
        end

        private

        def pid
          ::Process.pid
        end

        def tid
          ::Thread.current.object_id.to_s(36)
        end

        def context
          ::Thread.current[:sidekiq_context]
        end

        def memory
          `ps -o rss= -p #{::Process.pid}`.chomp.to_i
        end

        def elapsed(start)
          return nil if start.nil?

          (Time.current - start).to_f.round(3)
        end

        def filter_fields(data)
          data.each do |key, val|
            next unless val.is_a?(String) && val.length > 32_766

            data[key] = "[omitted; length = #{val.length}, max = 32766]"
          end

          data
        end
      end
    end
  end
end
