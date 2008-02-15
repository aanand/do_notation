require 'spec/rake/spectask'

task :default => :test

desc "Run all specs"
Spec::Rake::SpecTask.new('test') do |t|
  t.spec_files = FileList['test/specs.rb']
end

desc "Run all specs with RCov"
Spec::Rake::SpecTask.new('rcov') do |t|
  t.spec_files = FileList['test/specs.rb']
  t.rcov = true
end
