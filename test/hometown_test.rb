require 'minitest/autorun'
require 'hometown'

class HometownTest < Minitest::Test
  class Corvallis
  end

  class Portland
  end

  def setup
    Hometown.watch(Corvallis)
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

end
