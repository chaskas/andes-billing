module Billing
  class ApplicationController < ::ApplicationController
    layout 'application' if Rails.application.class.name.deconstantize == 'Andes'
  end
end
