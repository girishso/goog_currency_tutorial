require 'bundler'
Bundler.require

disable :run
set :root, File.dirname(__FILE__) + "/.."
require Sinatra::Application.root + '/app'

Capybara.app = Sinatra::Application

RSpec.configure do |config|
  config.include Capybara::DSL
end

valid_response =<<-VALID
{lhs: "1 U.S. dollar",rhs: "54.836587 Indian rupees",error: "",icc: true}
VALID

describe 'currency converter' do
  it "loads currency converter form" do
    visit "/"
    page.should have_content("Currency Converter")
    find('form').should have_button('Convert')
  end

  it "converts currencies" do
    FakeWeb.register_uri(:get,
                       "http://www.google.com/ig/calculator?hl=en&q=1USD=?INR",
                       :status => "200",
                       :body => valid_response)
    visit '/'

    fill_in "amount", :with => 1
    select "USD", :from => "from"
    select "INR", :from => "to"
    click_button 'Convert'

    find("#result").should have_content('54.836587')
  end

  it "handles errors"
end

