guard :minitest, :test_folders => ['test'], :all_after_pass => true do
  watch(%r{^lib/(.+)\.rb$})     { |m| "test/#{m[1]}_test.rb" }
  watch(%r{^lib/.*\.rb$})       { |m| "test/hometown_test.rb" }
  watch(%r{^test/.+_test\.rb$})
end

