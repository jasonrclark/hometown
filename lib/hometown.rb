require "hometown/hooks"
require "hometown/trace"
require "hometown/version"
require "hometown/watch"
require "hometown/watch_for_disposal"

module Hometown
  HOMETOWN_TRACE_ON_INSTANCE = :@__hometown_creation_backtrace

  @undisposed = {}
  @patched    = {}

  def self.watch(clazz)
    return if already_patched?(clazz)

    @patched[clazz] = true
    Watch.patch(clazz)
  end

  def self.watch_for_disposal(clazz, disposal_method)
    return if already_patched?(clazz)

    watch(clazz)
    WatchForDisposal.patch(clazz, disposal_method)
  end

  def self.already_patched?(clazz)
    @patched.include?(clazz)
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

    @undisposed[trace] ||= 0
    @undisposed[trace]  += 1
  end

  def self.mark_disposed(instance)
    trace = Hometown.for(instance)

    if @undisposed[trace]
      @undisposed[trace] -= 1
    end
  end
end
