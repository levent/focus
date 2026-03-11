require "capybara/cuprite"

Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(app, window_size: [ 1280, 800 ], headless: true)
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :cuprite
  end
end
