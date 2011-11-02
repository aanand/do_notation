require 'rspec/core/rake_task'

spec_pattern = 'test/*.rb'

task :default => :spec

desc "Run all specs"
RSpec::Core::RakeTask.new('spec') do |t|
  t.pattern = spec_pattern
end

desc "Run all specs with RCov"
RSpec::Core::RakeTask.new('rcov') do |t|
  t.pattern = spec_pattern
  t.rcov = true
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "do_notation"
    gemspec.summary = 'Haskell-style monad do-notation for Ruby'
    gemspec.description = 'Haskell-style monad do-notation for Ruby'
    gemspec.email = 'aanand.prasad@gmail.com'
    gemspec.homepage = 'http://github.com/aanand/do_notation'
    gemspec.authors = ["Aanand Prasad"]
    gemspec.add_dependency('ParseTree')
    gemspec.add_dependency('ruby2ruby', '1.1.9')
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
