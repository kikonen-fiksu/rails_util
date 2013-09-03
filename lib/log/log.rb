require 'logging'
require 'logging/config/yaml_configurator'

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

  #
  # Initialize logging for rails
  #
  # NOTE KI this should be called from "config/initializers"
  #
  def self.init
    configurator = Logging::Config::YamlConfigurator.new(read_logging_config_file, Rails.env)
    configurator.load

    if defined?(PhusionPassenger)
      PhusionPassenger.on_event(:starting_worker_process) do |forked|
        Logging.reopen if forked
      end
    end
  end

  #
  # Read config from "config" -dir
  #
  def self.read_logging_config_file
    config_file = File.join(Rails.root, 'config', 'logging.local.yml')
    unless File.exists? config_file
    config_file = File.join(Rails.root, 'config', 'logging.yml')
    end
    erb = ERB.new File.read(config_file)
    StringIO.new erb.result(binding)
  end

  #
  # Internal logging for Logging
  #
  def self.init_internal_logger
    logger = ::Logging::Logger[::Logging]
    logger.level = :warn
    logger.appenders = ::Logging::Appenders::Stderr.new 'Logging'
  end
end
