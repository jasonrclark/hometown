require "hometown/version"
require "hometown/trace"

module Hometown
  HOMETOWN_IVAR = :@__hometown_creation_backtrace

  def self.watch(clazz)
    clazz.define_singleton_method(:new) do |*args, &blk|
      trace = Hometown.create_trace(self, caller)

      instance = super(*args, &blk)
      instance.instance_variable_set(HOMETOWN_IVAR, trace)
      instance
    end
  end

  def self.for(instance)
    instance.instance_variable_get(HOMETOWN_IVAR)
  end

  def self.create_trace(clazz, backtrace)
    Trace.new(clazz, backtrace)
  end
end
