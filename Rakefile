require 'rspec/core/rake_task'

task :default => :spec

desc "Run all specs"
RSpec::Core::RakeTask.new('spec')

desc "Run all specs with RCov"
RSpec::Core::RakeTask.new('rcov') do |t|
  t.rcov = true
end
