require_relative 'ruby_prof_profiler'

module Profiler
  #
  # profile &block
  #
  def self.profile(file_name)
    result = nil
    prof = RubyProfProfiler.instance
    if prof.enabled?
      prof.start
      begin
        result = yield
      ensure
        prof.end file_name
      end
    else
      result = yield
    end
    result
  end
end
