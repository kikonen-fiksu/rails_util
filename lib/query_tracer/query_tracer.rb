#
# Simple query tracer, which seems to do its' job.
#
# @see http://blog.pablobm.com/post/13819923571/activerecord-backtrace-sql-queries
#
module QueryTracer
  def self.start!
    # Tap into notifications framework. Subscribe to sql.active_record messages
    ActiveSupport::Notifications.subscribe('sql.active_record') do |*args|
      QueryTracer.publish(*args)
    end
  end

  # Notice the 5 arguments that we can expect
  def self.publish(name, started, ended, id, payload)
    name = payload[:name]
    sql = payload[:sql]

    # Print out to logs
    msg = "CALLED: #{name} - #{sql}"
    clean_trace.each do |line|
      msg << "\n    #{line}"
    end
    Rails.logger.info msg
  end

  def self.clean_trace
    Rails.backtrace_cleaner.clean(caller[2..-1])
  end
end
