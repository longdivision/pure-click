require 'date'
require 'json'
require 'active_support/all'

class PureClick
  NEXT_BUTTON_SELECTOR = '#main > div.timetable-ctrls > span.pg-pager.next'

  def initialize(url, email_address, pin, schedule)
    @url = url
    @email_address = email_address
    @pin = pin
    @schedule = schedule
  end

  def book_classes
    session = Capybara::Session.new(:poltergeist)

    title_message('Starting booking process')

    login(session)
    navigate_to_bookings_page(session)
    navigate_to_bookings_7_days_from_now(session)
    try_to_book(session)
  end

  def login(session)
    info_message('Signing in')

    session.visit(@url)
    session.assert_text(/Member Login/i)
    session.click_link('Member login')
    session.fill_in('edit-email', with: @email_address)
    session.fill_in('edit-pincode', with: @pin)
    session.click_button('Log in')
    session.assert_text(/My Bookings/i)
  end

  def navigate_to_bookings_page(session)
    info_message('Navigating to bookings page')

    session.visit(@url + 'members/bookings')
    session.assert_text(/Book a class/i)
  end

  def navigate_to_bookings_7_days_from_now(session)
    info_message('Navigating 7 days into the future')

    7.times do |i|
      session.find(NEXT_BUTTON_SELECTOR).click

      london = ActiveSupport::TimeZone.new('London')
      one_week_from_now = Time.now.in_time_zone(london).to_date + (i + 1).days
      expected_day = (one_week_from_now.mday).ordinalize
      expected_date = one_week_from_now.strftime("%A #{expected_day} %B").upcase
      session.assert_text(expected_date)
    end
  end

  def try_to_book(session)
    info_message('Attempting to book classes')

    london = ActiveSupport::TimeZone.new('London')
    today = Time.now.in_time_zone(london).to_date
    seven_days_from_now = today + 7.days
    class_wishlist = @schedule[today.strftime('%A')] || []

    class_wishlist.each do |time, class_name|
      matching_class_blocks = session.all(
        :xpath, "//*[text()='#{class_name}']/../..").select do | elem |
        elem.has_text?(time)
      end
      matching_class_block = matching_class_blocks.first

      begin
        matching_class_block.find_link('Book').trigger(:click)
        info_message("✔ Booking Made for #{class_name} at #{time}, " +
                       "#{seven_days_from_now}")
        sleep 5
      rescue
        info_message("✘ Unable to book #{class_name} at #{time}, " +
          "#{seven_days_from_now}")
      end
    end
  end

  def title_message(text)
    puts "=> #{text}"
  end

  def info_message(text)
    puts "- #{text}"
  end
end
