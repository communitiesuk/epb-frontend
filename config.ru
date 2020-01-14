require File.expand_path('lib/app', File.dirname(__FILE__))

container = Container.new
run FrontendService.new(container)
