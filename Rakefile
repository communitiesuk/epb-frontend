require "sinatra"
configure { set :server, :puma }
Dir.glob("lib/tasks/*.rake").each { load File.expand_path(it) }

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)
