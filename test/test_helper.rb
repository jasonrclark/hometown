require 'minitest/autorun'

if ENV["CI"]
  require 'coveralls'
  Coveralls.wear!
end
