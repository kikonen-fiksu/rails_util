require_relative 'ruby_prof_profiler'

module Profiler
  def self.set_config(config = {})
    RubyProfProfiler.set_config(config)
  end

  def self.start
    RubyProfProfiler.instance.start
  end

  def self.end(file_name)
    RubyProfProfiler.instance.end(file_name)
  end

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
