require "importmap-rails"
require "turbo-rails"
require "stimulus-rails"

module Billing
  class Engine < ::Rails::Engine
    isolate_namespace Billing

    initializer "billing.assets" do |app|
      app.config.assets.paths << root.join("app/javascript")
      app.config.assets.precompile += %w[ billing_manifest ]
    end

    initializer "billing.importmap", before: "importmap" do |app|
      app.config.importmap.paths << root.join("config/importmap.rb")
      app.config.importmap.cache_sweepers << root.join("app/javascript")
    end
  end
end
