require "hometown/version"
require "hometown/trace"

module Hometown
  HOMETOWN_TRACE_ON_INSTANCE = :@__hometown_creation_backtrace

  def self.watch(clazz)
    return if clazz.respond_to?(:hometown_traced?)

    class << clazz
      def new_traced(*args, &blk)
        trace = Hometown.create_trace(self, caller)

        instance = new_original(*args, &blk)
        instance.instance_variable_set(HOMETOWN_TRACE_ON_INSTANCE, trace)
        instance
      end

      def hometown_traced?
        true
      end

      alias_method :new_original, :new
      alias_method :new, :new_traced
    end
  end

  def self.for(instance)
    instance.instance_variable_get(HOMETOWN_TRACE_ON_INSTANCE)
  end

  def self.create_trace(clazz, backtrace)
    Trace.new(clazz, backtrace)
  end
end
