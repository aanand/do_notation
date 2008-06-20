require 'spec/rake/spectask'

spec_list = FileList['test/*.rb']

task :default => :test

desc "Run all specs"
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = spec_list
end

desc "Run all specs with RCov"
Spec::Rake::SpecTask.new('rcov') do |t|
  t.spec_files = spec_list
  t.rcov = true
end

require 'echoe'

Echoe.new('ruby-do-notation') do |p|
  p.author = 'Aanand Prasad'
  p.summary = 'Haskell-style monad do-notation for Ruby'
  p.email = 'aanand.prasad@gmail.com'
  p.url = 'http://github.com/aanand/ruby-do-notation/tree/master'
  p.version = '0.1'
  p.dependencies = ['ParseTree', 'ruby2ruby']
end