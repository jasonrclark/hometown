require "hometown/trace"
require "hometown/version"
require "hometown/watch"
require "hometown/watch_for_disposal"

module Hometown
  HOMETOWN_TRACE_ON_INSTANCE = :@__hometown_creation_backtrace

  def self.watch(clazz)
    Watch.patch(clazz)
  end

  def self.watch_for_disposal(clazz, disposal_method)
    WatchForDisposal.patch(clazz, disposal_method)
  end

  def self.for(instance)
    instance.instance_variable_get(HOMETOWN_TRACE_ON_INSTANCE)
  end

  def self.undisposed
    WatchForDisposal.undisposed()
  end
end
