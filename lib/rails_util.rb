require 'rails_util/version'
require 'profiler/profiler'
require 'query_tracer/query_tracer'
require 'log/log'

module RailsUtil
  DEFAULT_CONFIG = {
    root_dir: '.',
  }.freeze

  def self.set_config(config = {})
    @@config = DEFAULT_CONFIG.merge(config).freeze
  end

  def self.config
    @@config
  end

  self.set_config
end
