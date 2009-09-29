require 'spec/rake/spectask'

spec_list = FileList['test/*.rb']

task :default => :spec

desc "Run all specs"
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = spec_list
end

desc "Run all specs with RCov"
Spec::Rake::SpecTask.new('rcov') do |t|
  t.spec_files = spec_list
  t.rcov = true
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "do-notation"
    gemspec.summary = 'Haskell-style monad do-notation for Ruby'
    gemspec.description = 'Haskell-style monad do-notation for Ruby'
    gemspec.email = 'aanand.prasad@gmail.com'
    gemspec.homepage = 'http://github.com/aanand/do-notation'
    gemspec.authors = ["Aanand Prasad"]
    gemspec.add_dependency('ParseTree')
    gemspec.add_dependency('ruby2ruby', '1.1.9')
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
