module Hometown
  class Hooks
    def initialize
      @hooks = []
    end

    def <<(hook)
      @hooks << hook
    end

    def run_on(instance)
      @hooks.each do |hook|
        hook.call(instance)
      end
    end
  end
end
