require "hometown/hooks"
require "hometown/trace"
require "hometown/version"
require "hometown/watch"
require "hometown/watch_for_disposal"

module Hometown
  HOMETOWN_TRACE_ON_INSTANCE = :@__hometown_creation_backtrace

  @undisposed      = Hash.new(0)
  @watched_classes = {}
  @dispose_class   = {}

  def self.watch(clazz)
    return if @watched_classes.include?(clazz)

    @watched_classes[clazz] = true
    Watch.patch(clazz)
  end

  def self.watch_for_disposal(clazz, disposal_method)
    return if @dispose_class.include?(clazz)

    watch(clazz)

    @dispose_class[clazz] = true
    WatchForDisposal.patch(clazz, disposal_method)
  end

  def self.for(instance)
    instance.instance_variable_get(HOMETOWN_TRACE_ON_INSTANCE)
  end

  def self.undisposed()
    @undisposed
  end

  def self.create_trace(clazz, backtrace)
    Trace.new(clazz, backtrace)
  end

  def self.mark_for_disposal(instance)
    trace = Hometown.for(instance)
    @undisposed[trace] += 1
  end

  def self.dispose_of(instance)
    trace = Hometown.for(instance)

    if @undisposed[trace]
      @undisposed[trace] -= 1
    end
  end
end
