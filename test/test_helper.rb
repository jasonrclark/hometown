if ENV["CI"]
  require 'coveralls'
  Coveralls.wear!
end

require 'minitest/autorun'
