module Hometown
  module Watch
    @watched_classes = {}

    def self.patch(clazz, on_instance_created=nil)
      update_on_instance_created(clazz, on_instance_created)

      return if @watched_classes.include?(clazz)
      @watched_classes[clazz] = true

      clazz.instance_eval do
        class << self
          def new_traced(*args, &blk)
            trace = Hometown::Trace.new(self, caller)

            instance = new_untraced(*args, &blk)
            instance.instance_variable_set(HOMETOWN_TRACE_ON_INSTANCE, trace)
            @instance_hooks.each { |hook| hook.call(instance) } if @instance_hooks

            instance
          end

          alias_method :new_untraced, :new
          alias_method :new, :new_traced
        end
      end
    end

    # This hook allows other tracing in Hometown to get a whack at an object
    # after it's been created without forcing them to patch new themselves
    def self.update_on_instance_created(clazz, on_instance_created)
      return unless on_instance_created
      clazz.instance_eval do
        @instance_hooks ||= []
        @instance_hooks << on_instance_created
      end
    end
  end
end
