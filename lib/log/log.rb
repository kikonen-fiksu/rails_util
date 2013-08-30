#
# Helpers for utilizing Logging
#
module Log
  NDC = Logging.ndc

  #
  # Simple, properly balanced NDC block
  #
  # @param name Symbol or String
  #
  def self.ndc(name)
    NDC.push name
    begin
      yield
    ensure
      NDC.pop
    end
  end

  #
  # @param count max entries from stack
  #
  # @return stacktrace array for current execution point
  #
  def self.backtrace(count = 20)
    raise StandardError.new
  rescue => e
    e.backtrace[1..count]
  end

end
