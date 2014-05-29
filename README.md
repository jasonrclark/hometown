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

Enable instance creation tracking on a class via:

    Hometown.track(::Thread)

To determine calling location for a specific object:

    Hometown.home_for(thread)

## Contributing

1. Fork it ( https://github.com/[my-github-username]/hometown/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
