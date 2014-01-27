require 'singleton'
require 'logging'
require 'ruby-prof'

module Profiler
#
# TODO KI make gem out of this...
#
# @see https://github.com/ruby-prof/ruby-prof
#
class RubyProfProfiler
  DEFAULT_CONFIG = {
    root_dir: '.',
    profile_dir: 'log/profile',
    enabled: true,
    cpu: false,
    memory: false,
    min_percent: 10.0,
    min_profile_time: 10,
    output: :graph
  }.freeze

  include Singleton

  def initialize
    @file_index = 0

    @output_dir = nil

    config = @@config
    @enabled = config[:enabled]
    @root_dir = config[:root_dir]
    @profile_dir = config[:profile_dir]

    @cpu = config[:cpu]
    @memory = config[:memory]
    @min_percent = config[:min_percent]
    @min_profile_time = config[:min_profile_time]
    @output = config[:output]
    @output = @output.to_s.to_sym

    if @enabled
      @output_dir = "#{@root_dir}/#{@profile_dir}"
      unless Dir.exist? @output_dir
        Dir.mkdir @output_dir
      end

      if @memory
        RubyProf.measure_mode = RubyProf::MEMORY
      end
      if @cpu
        RubyProf.measure_mode = RubyProf::WALL_TIME
      end
    end
  end

  def logger
    @logger ||= Logging.logger['Profile']
  end


  def enabled?
    @enabled
  end

  def self.set_config(config = {})
    @@config = DEFAULT_CONFIG.merge(config)
  end

  #
  # @return profile file residing in profiling dir
  #
  def full_file(file_name)
    @file_index += 1
    File.join @output_dir, "#{DateTime.now.strftime '%Y%m%d_%H%M'}_#{'%04d' % @file_index}_#{file_name}"
  end

  def start
    return unless @enabled
    RubyProf.start
    @profile_start_time = Time.now
  end

  def end(file_name)
    return unless @enabled
    results = RubyProf.stop

    profile_start_time = @profile_start_time
    @profile_start_time = nil
    profile_end_time = Time.now

    diff = profile_end_time - profile_start_time
    if diff < @min_profile_time
      logger.info "skipping: too_short_time, file=#{file_name}, time=#{diff}s, min=#{@min_profile_time}s"
      return
    end

    # ensure name is safe
    file_name = file_name
      .gsub(/^.*(\\|\/)/, '')
      .gsub!(/[^0-9A-Za-z.\-]/, '_')
    base_name = full_file(file_name)

    #      results.eliminate_methods!([/ProfileHelper/])

    if @output == :graph
      File.open "#{base_name}-graph.html", 'w' do |file|
        logger.info "Saving: #{file.path}"
        RubyProf::GraphHtmlPrinter.new(results).print file, min_percent: @min_percent
      end
    elsif @output == :call_stack
      File.open "#{base_name}-stack.html", 'w' do |file|
        logger.info "Saving: #{file}"
        RubyProf::CallStackPrinter.new(results).print file, min_percent: @min_percent
      end
    elsif @profile == :flat
      File.open "#{base_name}-flat.txt", 'w' do |file|
        logger.info "Saving: #{file}"
        RubyProf::FlatPrinter.new(results).print file, min_percent: @min_percent
      end
    elsif @profile == :call_tree
      File.open "#{base_name}-tree.prof", 'w' do |file|
        logger.info "Saving: #{file}"
        RubyProf::CallTreePrinter.new(results).print file, min_percent: @min_percent
      end
    end
  end
end

RubyProfProfiler.set_config
end
