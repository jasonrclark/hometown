require 'minitest/autorun'
require 'hometown'

class HometownTest < Minitest::Test
  class Corvallis
    def leave
    end
  end

  class Portland
  end

  class Nottingham
    def initialize(&blk)
      blk.call
    end
  end

  def setup
    Hometown.watch(Corvallis, :dispose => :leave)
    @corvallis = Corvallis.new
  end

  def test_untraced_class
    town = Portland.new
    assert_nil Hometown.for(town)
  end

  def test_tracing_includes_classname
    result = Hometown.for(@corvallis)
    assert_equal Corvallis, result.traced_class
  end

  def test_tracing_includes_this_file
    result = Hometown.for(@corvallis)
    assert_includes result.backtrace.join("\n"), __FILE__
  end

  def test_initialize_with_block
    Hometown.watch(Nottingham)
    nottingham = Nottingham.new do
      i = 1
    end

    result = Hometown.for(nottingham)
    assert_equal Nottingham, result.traced_class
  end

  def test_core_class
    Hometown.watch(::Thread)
    thread = Thread.new { sleep 1 }

    result = Hometown.for(thread)
    assert_equal ::Thread, result.traced_class
  end

  def test_marks_for_disposal
    result = Hometown.undisposed
    trace = Hometown.for(@corvallis)
    assert_equal 1, result[trace]
  end
end
