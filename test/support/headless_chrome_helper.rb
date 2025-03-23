# frozen_string_literal: true

# This file provides configuration for headless Chrome in system tests
# It is used by application_system_test_case.rb

module Billing
  module HeadlessChromeHelper
    # Configure Capybara to use headless Chrome when HEADLESS environment variable is set
    def self.configure_headless_chrome
      return unless ENV['HEADLESS'] == 'true'

      # Configure Capybara to use headless Chrome
      Capybara.register_driver :selenium_chrome_headless do |app|
        options = Selenium::WebDriver::Chrome::Options.new
        options.add_argument('--headless')
        options.add_argument('--disable-gpu')
        options.add_argument('--no-sandbox')
        options.add_argument('--disable-dev-shm-usage')

        Capybara::Selenium::Driver.new(
          app,
          browser: :chrome,
          options: options
        )
      end

      # Set the default driver to headless Chrome
      Capybara.javascript_driver = :selenium_chrome_headless
    end
  end
end
