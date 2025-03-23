# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "support/headless_chrome_helper"

# Configure headless Chrome if HEADLESS environment variable is set
Billing::HeadlessChromeHelper.configure_headless_chrome

module Billing
  class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
    # Use headless Chrome if HEADLESS environment variable is set, otherwise use regular Chrome
    driven_by :selenium, using: (ENV['HEADLESS'] == 'true' ? :headless_chrome : :chrome), screen_size: [1400, 1400]
  end
end
