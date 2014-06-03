require 'hometown'

class Disposable
  def dispose
    # always be disposing
  end
end

# Watch Disposable and track calls to dispose
Hometown.watch_for_disposal(Disposable, :dispose)

# Creating initial object
disposable = Disposable.new
puts "Still there!"
p Hometown.undisposed()

# All done!
disposable.dispose
puts "Properly disposed"
p Hometown.undisposed()
