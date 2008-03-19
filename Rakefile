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
