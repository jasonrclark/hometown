module Hometown
  class DisposalTracer
    attr_reader :undisposed

    def initialize
      @undisposed      = Hash.new(0)
      @tracing_classes = {}
    end

    def patch(clazz, disposal_method)
      return if @tracing_classes.include?(clazz)
      @tracing_classes[clazz] = true

      trace_creation(clazz)
      patch_disposal_method(clazz, disposal_method)
    end

    def trace_creation(clazz)
      Hometown.creation_tracer.patch(clazz, method(:mark_for_disposal))
    end

    def patch_disposal_method(clazz, disposal_method)
      traced   = "#{disposal_method}_traced"
      untraced = "#{disposal_method}_untraced"

      clazz.class_eval do
        define_method(traced) do |*args, &blk|
          Hometown.disposal_tracer.notice_disposed(self)
          self.send(untraced, *args, &blk)
        end

        alias_method untraced, disposal_method
        alias_method disposal_method, traced
      end
    end

    def mark_for_disposal(instance)
      trace = Hometown.for(instance)
      @undisposed[trace] += 1
    end

    def notice_disposed(instance)
      trace = Hometown.for(instance)
      @undisposed[trace] -= 1 if @undisposed[trace]
    end

    def undisposed_report
      result = "Undisposed Resources:\n"
      @undisposed.each do |trace, count|
        result += "[#{trace.traced_class}] => #{count}\n"
        result += "\t#{trace.backtrace.join("\n\t")}\n\n"
      end

      result += "Undiposed Totals:\n"
      @undisposed.group_by { |trace, _| trace.traced_class }.each do |clazz, counts|
        count = counts.map { |count| count.last }.inject(0, &:+)
        result += "[#{clazz}] => #{count}"
      end
      result
    end
  end
end
