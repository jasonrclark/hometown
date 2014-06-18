module Hometown
  module WatchForDisposal
    @undisposed    = Hash.new(0)
    @dispose_class = {}

    def self.undisposed
      @undisposed
    end

    def self.patch(clazz, disposal_method)
      return if @dispose_class.include?(clazz)
      @dispose_class[clazz] = true

      watch_class(clazz)
      patch_disposal_method(clazz, disposal_method)
    end

    def self.watch_class(clazz)
      Hometown.creation_tracer.patch(clazz, Proc.new do |instance|
        mark_for_disposal(instance)
      end)
    end

    def self.patch_disposal_method(clazz, disposal_method)
      traced   = "#{disposal_method}_traced"
      original = "#{disposal_method}_untraced"

      clazz.class_eval do
        define_method(traced) do |*args, &blk|
          Hometown::WatchForDisposal.notice_disposed(self)
          self.send(original, *args, &blk)
        end

        alias_method original, disposal_method
        alias_method disposal_method, traced
      end
    end

    def self.mark_for_disposal(instance)
      trace = Hometown.for(instance)
      @undisposed[trace] += 1
    end

    def self.notice_disposed(instance)
      trace = Hometown.for(instance)
      @undisposed[trace] -= 1 if @undisposed[trace]
    end
  end
end
