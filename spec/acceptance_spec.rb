require 'bundler'
Bundler.require

disable :run
set :root, File.dirname(__FILE__) + "/.."
require Sinatra::Application.root + '/app'

Capybara.app = Sinatra::Application

RSpec.configure do |config|
  config.include Capybara::DSL
end
