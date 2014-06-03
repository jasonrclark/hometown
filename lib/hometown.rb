require "hometown/version"
require "hometown/trace"

module Hometown
  HOMETOWN_TRACE_ON_INSTANCE = :@__hometown_creation_backtrace

  @undisposed = {}

  module Watch
    def self.patch(clazz)
      clazz.instance_eval do
        @after_create_hooks = []

        class << self
          def new_traced(*args, &blk)
            trace = Hometown.create_trace(self, caller)

            instance = new_original(*args, &blk)
            instance.instance_variable_set(HOMETOWN_TRACE_ON_INSTANCE, trace)
            run_after_create_hooks(instance)

            instance
          end

          def run_after_create_hooks(instance)
            hooks = instance.class.instance_variable_get(:@after_create_hooks)
            hooks.each do |hook|
              hook.call(instance)
            end
          end

          alias_method :new_original, :new
          alias_method :new, :new_traced
        end

      end
    end
  end

  module WatchForDisposal
    def self.patch(clazz)
      hooks = clazz.instance_variable_get(:@after_create_hooks)
      hooks << Proc.new do |instance|
        Hometown.mark_for_disposal(instance)
      end
    end
  end

  def self.watch(clazz)
    @patched ||= {}
    if @patched[clazz]
      false
    else
      @patched[clazz] = true
      Watch.patch(clazz)
      true
    end
  end

  def self.watch_for_disposal(clazz, disposal_method)
    return unless watch(clazz)

    WatchForDisposal.patch(clazz)
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
end
