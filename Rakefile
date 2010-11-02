require 'rubygems'
require 'rake'

$:.unshift 'lib'
require 'pickled_optparse/version'
version = PickledOptparse::Version::STRING

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.required_ruby_version = '~> 1.9.2' # Everyone should upgrade, now!
    gem.name = "pickled_optparse"
    gem.version = version
    gem.summary = %Q{Adds required switches to Ruby's OptionParser class}
    gem.description = %Q{Adds the ability to easily specify and test for required switches in Ruby's built-in OptionParser class}
    gem.email = "picklepumpers@gmail.com"
    gem.homepage = "http://github.com/PicklePumpers/pickled_optparse"
    gem.authors = ["Mike Bethany"]
    gem.add_development_dependency "rspec", ">= 2.0.1"
    gem.add_development_dependency "syntax", ">= 1.0.0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |t| 
  t.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb"] 
  t.pattern = 'spec/*/*_spec.rb' 
end
task :spec => :check_dependencies

# Build rdocs
require 'rake/rdoctask'
require 'syntax/convertors/html'
rdoc_dir = 'rdoc'
# This is rdoc1 but it doesn't work unless you DON'T wrap it in a task
# Generate html files from example ruby files
convertor = Syntax::Convertors::HTML.for_syntax "ruby"
replacement_key = "REPLACE_THIS_TEXT_WITH_PROPER_HTML"
# Create dummy files
Dir.glob('examples/*.rb').each do |file|
  File.open("#{file}.txt", "w") do |dummy_file|
    dummy_file.write(replacement_key)
  end
end

# Call the rdoc task
Rake::RDocTask.new(:rdoc2) do |rdoc|
  rdoc.rdoc_dir = rdoc_dir
  rdoc.title = "pickled_optparse #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('HISTORY*')
  rdoc.rdoc_files.include('examples/*.txt')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :rdoc3 do
  # Now use a hammer to replace the dummy text with the
  # html we want to use in our ruby example code file.
  Dir.glob('examples/*.rb').each do |file|
    html_header = File.read('rake_reqs/html_header.html')
    html_ruby = convertor.convert(File.read(file))
    rdoc_file = "#{rdoc_dir}/examples/#{File.basename(file,".rb")}_rb_txt.html"
    fixed_html = File.read(rdoc_file).gsub!(replacement_key, "#{html_header}#{html_ruby}")
    File.open(rdoc_file, "w") {|f| f.write(fixed_html)}
    File.delete("#{file}.txt")
  end
end

task :rdoc => [:rdoc2, :rdoc3]

task :default => :spec
