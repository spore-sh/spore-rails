require "spore"

Spore.instrumenter = ActiveSupport::Notifications

# Watch all loaded env files with Spring
begin
  require "spring/watcher"
  ActiveSupport::Notifications.subscribe(/^spore/) do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    Spring.watch event.payload[:env].filename if Rails.application
  end
rescue LoadError
  # Spring is not available
end

module Spore
  # Spore Railtie for using Spore to load environment from a file into
  # Rails applications
  class Railtie < Rails::Railtie
    config.before_configuration { load }

    # Public: Load spore
    #
    # This will get called during the `before_configuration` callback, but you
    # can manually call `Spore::Railtie.load` if you needed it sooner.
    def load
      Spore.load
    end

    # Internal: `Rails.root` is nil in Rails 4.1 before the application is
    # initialized, so this falls back to the `RAILS_ROOT` environment variable,
    # or the current working directory.
    def root
      Rails.root || Pathname.new(ENV["RAILS_ROOT"] || Dir.pwd)
    end

    # Rails uses `#method_missing` to delegate all class methods to the
    # instance, which means `Kernel#load` gets called here. We don't want that.
    def self.load
      instance.load
    end
  end
end
