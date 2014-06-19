require "bundler/gem_tasks"

require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |test|
  test.verbose = true
  test.libs << "test"
  test.libs << "lib"
  test.test_files = FileList['test/**/*_test.rb']
end

Rake::Task['release:push_source_control'].clear
task 'release:push_source_control' do
  #require 'pry';require 'pry-nav'; binding.pry;

  `git push origin master`

  version = Bundler::GemHelper.gemspec.version
  version_tag = "v#{version}"
  `git tag -a -m \"Version #{version}\" #{version_tag}`
  `git push --tags`
end
