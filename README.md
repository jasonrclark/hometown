# Hometown
[![Gem Version](https://badge.fury.io/rb/hometown.svg)](http://badge.fury.io/rb/hometown)

Track object creation to stamp out pesky leaks.

## Requirements
Currently I'm testing against Ruby 2.1, but will be extending that in the future. I expect to allow back to 1.9.x, JRuby and Rubinius.

## Installation

    $ gem install hometown

## Usage

Find where an object was created:

```
# examples/example.rb
require 'hometown'

# Start watching Array instantiations
Hometown.watch(Array)

# Output the trace for a specific Array's creation
p Hometown.for(Array.new)


$ ruby examples/example.rb

#<Hometown::Trace:0x007fcd9c95ca10
  @traced_class=Array,
  @backtrace=["script:4:in `<main>'"]>
```


Track disposal of an object:

```
# dispose.rb
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


$ ruby examples/dispose.rb

Still there!
{ #<Hometown::Trace:0x007f9aa516ec88 ...> => 1 }

Properly disposed!
{ #<Hometown::Trace:0x007f9aa516ec88 ...> => 0 }
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/hometown/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
