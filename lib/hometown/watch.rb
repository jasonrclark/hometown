module Hometown
  module Watch
    def self.patch(clazz)
      clazz.instance_eval do
        @hooks = Hooks.new

        class << self
          def new_traced(*args, &blk)
            trace = Hometown.create_trace(self, caller)

            instance = new_untraced(*args, &blk)
            instance.instance_variable_set(HOMETOWN_TRACE_ON_INSTANCE, trace)
            instance.class.instance_variable_get(:@hooks).run_on(instance)

            instance
          end

          alias_method :new_untraced, :new
          alias_method :new, :new_traced
        end

      end
    end
  end
end
