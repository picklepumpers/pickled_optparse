require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.required_ruby_version = '~> 1.9.2'
    gem.name = "pickled_optparse"
    gem.summary = %Q{Adds required switches to the OptionParser class}
    gem.description = %Q{Adds the ability to easily specify and test for required switches in Ruby's built-in OptionParser class}
    gem.email = "picklepumpers@gmail.com"
    gem.homepage = "http://github.com/PicklePumpers/pickled_optparse"
    gem.authors = ["Mike Bethany"]
    gem.add_development_dependency "rspec", ">= 2.0.1"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new do |t| 
  t.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb"] 
  t.pattern = 'spec/*_spec.rb' 
end

RSpec::Core::RakeTask.new(:rcov) do |t|
  t.rcov_opts =  %q[--exclude "spec"]
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "pickled_optparse #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
