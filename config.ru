require File.expand_path('lib/app', File.dirname(__FILE__))

container = Container.new(OAuth2::Client)
run FrontendService.new(container)
