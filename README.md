spore-rails
-----------

Ruby/Rails gem to load Spore environment variables. See the [Spore Website](https://spore.sh) for more information.


## Installation

### Rails

Add this line to the top of your application's Gemfile:

```ruby
gem 'spore-rails'
```

And then execute:

```shell
$ bundle
```

#### Note on load order

Spore is initialized in your Rails app during the `before_configuration` callback, which is fired when the `Application` constant is defined in `config/application.rb` with `class Application < Rails::Application`. If you need it to be initialized sooner, you can manually call `Spore::Railtie.load`.

```ruby
# config/application.rb
Bundler.require(*Rails.groups)

Spore::Railtie.load

HOSTNAME = ENV['HOSTNAME']
```

If you use gems that require environment variables to be set before they are loaded, then list `spore-rails` in the `Gemfile` before those other gems and require `spore/rails-now`.

```ruby
gem 'spore-rails', :require => 'spore/rails-now'
gem 'gem-that-requires-env-variables'
```

### Sinatra or Plain ol' Ruby

Install the gem:

```shell
$ gem install spore
```

As early as possible in your application bootstrap process, load Spore:

```ruby
require 'spore'
Spore.load
```
To ensure Spore is loaded in rake, load the tasks:

```ruby
require 'spore/tasks'

task :mytask => :spore do
    # things that require environment variables
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Notes

The `spore-rails` gem was based on [`dotenv`](https://github.com/bkeepers/dotenv) by Brandon Keepers.
