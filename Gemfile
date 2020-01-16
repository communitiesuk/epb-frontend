# frozen_string_literal: true

ruby '~>2.6'

source 'https://rubygems.org' do
  group :development do
    gem 'prettier', '~> 0.16.0'
    gem 'sinatra-contrib'
  end

  group :test do
    gem 'rack-test', '~> 0.8.3'
    gem 'rspec', '~>3.0'
    gem 'webmock', '~> 3.7'
  end

  gem 'epb_auth_tools',
      git: 'https://github.com/communitiesuk/epb-auth-tools', branch: 'master'
  gem 'i18n'
  gem 'rack-contrib'
  gem 'rake'
  gem 'sassc', '~> 2.2'
  gem 'sinatra', '~> 2.0', '>= 2.0.7'
  gem 'sinatra-url-for',
      git: 'https://github.com/emk/sinatra-url-for.git', branch: 'master'
  gem 'zeitwerk', '~> 2.2.2'
end
