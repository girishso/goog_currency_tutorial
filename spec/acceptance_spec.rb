require 'bundler'
Bundler.require

disable :run
set :root, File.dirname(__FILE__) + "/.."
require Sinatra::Application.root + '/app'

Capybara.app = Sinatra::Application

RSpec.configure do |config|
  config.include Capybara::DSL
end

describe 'currency converter' do
  it "loads currency converter form" do
    visit "/"
    page.should have_content("Currency Converter")
    find('form').should have_button('Convert')
  end

  it "converts currencies"
  it "handles errors"
end

