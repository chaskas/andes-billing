# frozen_string_literal: true

require_relative "system_test_helper"

module Billing
  class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
    driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
  end
end
