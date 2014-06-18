module Hometown
  module WatchForDisposal
    def self.patch(clazz, disposal_method)
      add_disposal_hooks(clazz)
      patch_disposal_method(clazz, disposal_method)
    end

    def self.add_disposal_hooks(clazz)
      hooks = clazz.instance_variable_get(:@hooks)
      hooks << Proc.new do |instance|
        Hometown.mark_for_disposal(instance)
      end
    end

    def self.patch_disposal_method(clazz, disposal_method)
      traced   = "#{disposal_method}_traced"
      original = "#{disposal_method}_untraced"

      clazz.class_eval do
        define_method(traced) do |*args, &blk|
          Hometown.dispose_of(self)
          self.send(original, *args, &blk)
        end

        alias_method original, disposal_method
        alias_method disposal_method, traced
      end
    end
  end
end
