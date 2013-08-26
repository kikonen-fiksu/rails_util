require "ruby_prof_helper/version"
require "ruby_prof_helper/profile"

module RubyProfHelper
  #
  # profile &block
  #
  def self.profile(file_name)
    result = nil
    prof = Profile.instance
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
