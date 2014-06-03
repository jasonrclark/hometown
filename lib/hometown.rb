require "hometown/version"
require "hometown/trace"

module Hometown
  HOMETOWN_TRACE_ON_INSTANCE = :@__hometown_creation_backtrace

  module Watch
    def self.included(clazz)
      clazz.class_eval do
        @after_create_hooks = []

        def new_traced(*args, &blk)
          trace = Hometown.create_trace(self, caller)

          instance = new_original(*args, &blk)
          instance.instance_variable_set(HOMETOWN_TRACE_ON_INSTANCE, trace)
          run_after_create_hooks(instance)

          instance
        end

        def run_after_create_hooks(instance)
          hooks = instance.class.singleton_class.instance_variable_get(:@after_create_hooks)
          hooks.each do |hook|
            hook.call(instance)
          end
        end

        alias_method :new_original, :new
        alias_method :new, :new_traced
      end
    end
  end

  module WatchForDisposal
    def self.included(clazz)
      hooks = clazz.instance_variable_get(:@after_create_hooks)
      hooks << Proc.new do |instance|
        Hometown.mark_for_disposal(instance)
      end
    end
  end

  def self.watch(clazz)
    return false if clazz.singleton_class.ancestors.include?(Watch)

    class << clazz
      include Watch
    end
  end

  def self.watch_for_disposal(clazz, disposal_method)
    return unless watch(clazz)

    class << clazz
      include WatchForDisposal
    end
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

    @undisposed ||= {}
    @undisposed[trace] ||= 0
    @undisposed[trace]  += 1
  end
end
