module Hometown
  module WatchForDisposal
    def self.patch(clazz, disposal_method)
      hooks = clazz.instance_variable_get(:@hooks)
      hooks << Proc.new do |instance|
        Hometown.mark_for_disposal(instance)
      end

      clazz.class_eval do
        define_method("#{disposal_method}_traced") do |*args, &blk|
          Hometown.mark_disposed(self)
          self.send("#{disposal_method}_original", *args, &blk)
        end

        alias_method "#{disposal_method}_original", disposal_method
        alias_method disposal_method, "#{disposal_method}_traced"
      end
    end
  end
end
