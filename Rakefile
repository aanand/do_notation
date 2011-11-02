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
