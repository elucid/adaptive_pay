require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

# Rakefile
begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "elucid-adaptive_pay"
    gemspec.summary = "Wrapper around the Paypal Adaptive Payments API"
    gemspec.description = "Wrapper around the Paypal Adaptive Payments API"
    gemspec.email = %q{elucid@gmail.com}
    gemspec.homepage = "http://github.com/elucid/adaptive_pay"
    gemspec.authors = ["Frederik Fix", "Justin Giancola"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler -s http://gemcutter.org"
end

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the <%= file_name %> plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the <%= file_name %> plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = '<%= class_name %>'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
