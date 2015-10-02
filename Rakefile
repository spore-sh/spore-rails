desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -r spore.rb"
end

begin
  require "rspec/core/rake_task"

  RSpec::Core::RakeTask.new(:spec)

  task :default => :spec
rescue LoadError => e
  puts "RSpec could not be loaded: #{e.message}"
end
