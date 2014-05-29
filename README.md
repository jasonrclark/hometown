# Hometown

Track your object creation for helping stamp out pesky leaked object bugs.

## Installation

Add this line to your application's Gemfile:

    gem 'hometown'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hometown

## Usage

Determining the location of a particular object's instantation:

    # example.rb
    require 'hometown'

    Hometown.trace(Array)
    Hometown.home_for(Array.new)


    > ruby example.rb

    #<Hometown::Trace:0x007fcd9c95ca10
        @traced_class=Array,
        @backtrace=["script:4:in `<main>'"]>

## Contributing

1. Fork it ( https://github.com/[my-github-username]/hometown/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
