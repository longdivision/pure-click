require 'clockwork'
require_relative '../lib/capybara_manager'
require_relative '../lib/pure_click'

def book_classes
  CapybaraManager::register_driver

  url = ENV['PURE_URL']
  email = ENV['PURE_EMAIL']
  pin = ENV['PURE_PIN']
  schedule = JSON.parse(ENV['PURE_SCHEDULE'])

  PureClick.new(url, email, pin, schedule).book_classes
end

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  every(1.day, 'First booking attempt', at: '00:05', tz: 'Europe/London') do
    book_classes
  end

  every(1.day, 'Second booking attempt', at: '00:30', tz: 'Europe/London') do
    book_classes
  end

  every(1.day, 'Third booking attempt', at: '01:00', tz: 'Europe/London') do
    book_classes
  end

  every(1.day, 'Fourth booking attempt', at: '04:00', tz: 'Europe/London') do
    book_classes
  end
end
