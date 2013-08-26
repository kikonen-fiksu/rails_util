# -*- coding: utf-8 -*-
require 'singleton'
require 'logging'
require 'ruby-prof'
require 'rails_config'

module RubyProfHelper

#
# TODO KI make gem out of this...
#
# @see https://github.com/ruby-prof/ruby-prof
#
class Profile
  ROOT_DIR = '/tmp'

  LOG = Logging.logger['Profile']

  include Singleton

  def initialize
    @file_index = 0

    @enabled = true
    @profile_dir = '#{Rails.root}/log/profile'
    @min_percent = 10.0
    @cpu = true
    @memory = false
    @output = :graph

    prof = Settings.prof
    if prof
      @enabled = prof.enabled || @enabled
      @profile_dir = prof.profile_dir || @profile_dir

      @cpu = prof.cpu || @cpu
      @memory = prof.memory || @memory
      @min_percent = prof.min_percent || @min_percent
      @output = prof.output || @output
      @output = @output.to_s.to_sym
    end

    if @enabled
      @profile_dir = eval('"' + @profile_dir + '"')
      unless Dir.exist? @profile_dir
        Dir.mkdir @profile_dir
      end

      if @memory
        RubyProf.measure_mode = RubyProf::MEMORY
      end
      if @cpu
        RubyProf.measure_mode = RubyProf::WALL_TIME
      end
    end
  end

  def enabled?
    @enabled
  end

  #
  # @return profile file residing in profiling dir
  #
  def full_file(file_name)
    @file_index += 1
    File.join @profile_dir, "#{DateTime.now.strftime '%Y%m%d_%H%M'}_#{'%04d' % @file_index}_#{file_name}"
  end

  def start
    RubyProf.start
  end

  def end(file_name)
    base_name = full_file(file_name)
    results = RubyProf.stop
    #      results.eliminate_methods!([/ProfileHelper/])

    if @output == :graph
      File.open "#{base_name}-graph.html", 'w' do |file|
        LOG.info "Saving: #{file.path}"
        RubyProf::GraphHtmlPrinter.new(results).print file, min_percent: @min_percent
      end
    elsif @output == :call_stack
      File.open "#{base_name}-stack.html", 'w' do |file|
        LOG.info "Saving: #{file}"
        RubyProf::CallStackPrinter.new(results).print file, min_percent: @min_percent
      end
    elsif @profile == :flat
      File.open "#{base_name}-flat.txt", 'w' do |file|
        LOG.info "Saving: #{file}"
        RubyProf::FlatPrinter.new(results).print file, min_percent: @min_percent
      end
    elsif @profile == :call_tree
      File.open "#{base_name}-tree.prof", 'w' do |file|
        LOG.info "Saving: #{file}"
        RubyProf::CallTreePrinter.new(results).print file, min_percent: @min_percent
      end
    end
  end
end

end
