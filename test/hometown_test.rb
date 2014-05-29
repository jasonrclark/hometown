require 'minitest/autorun'
require 'hometown'

class HometownTest < Minitest::Test
  class Corvallis
  end

  class Portland
  end

  def setup
    Hometown.trace(Corvallis)
    @corvallis = Corvallis.new
  end

  def test_untraced_class
    town = Portland.new
    assert_nil Hometown.home_for(town)
  end

  def test_tracing_includes_classname
    result = Hometown.home_for(@corvallis)
    assert_equal Corvallis, result.traced_class
  end

  def test_tracing_includes_this_file
    result = Hometown.home_for(@corvallis)
    assert_includes result.backtrace.join("\n"), __FILE__
  end

end
