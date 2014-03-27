require 'capybara/rspec'
require 'capybara/dsl'

# Tell capybara to use css selectors, as opposed to xpath
Capybara.default_selector = :css

# Ajax can run a little slowly on some machines. Give it a chance.
Capybara.default_wait_time = 5

RSpec.configure do |config|
  config.include(Capybara::DSL)
end