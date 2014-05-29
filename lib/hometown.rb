require "hometown/version"
require "hometown/trace"

module Hometown
  HOMETOWN_IVAR = :@__hometown_creation_backtrace

  def self.trace(clazz)
    clazz.define_singleton_method(:new) do |*args|
      trace = Hometown.create_trace(self, caller)

      instance = super(*args)
      instance.instance_variable_set(HOMETOWN_IVAR, trace)
      instance
    end
  end

  def self.home_for(instance)
    instance.instance_variable_get(HOMETOWN_IVAR)
  end

  def self.create_trace(clazz, backtrace)
    Trace.new(clazz, backtrace)
  end
end
