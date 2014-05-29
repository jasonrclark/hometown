require 'minitest/autorun'
require 'hometown'

class HometownTest < Minitest::Test
  class Corvallis
  end

  class Portland
  end

  def test_untracked_class
    town = Portland.new
    assert_nil Hometown.home_for(town)
  end

  def test_tracking
    Hometown.track(Corvallis)
    town = Corvallis.new
    refute_nil Hometown.home_for(town)
  end

  def test_tracking_includes_classname
    Hometown.track(Corvallis)
    town = Corvallis.new
    assert_includes Hometown.home_for(town), "Corvallis"
  end

  def test_tracking_includes_this_file
    Hometown.track(Corvallis)
    town = Corvallis.new
    assert_includes Hometown.home_for(town), __FILE__
  end

end
