module Hometown
  class Trace
    attr_reader :traced_class, :backtrace

    def initialize(traced_class, backtrace)
      @traced_class = traced_class
      @backtrace    = backtrace
    end
  end
end
