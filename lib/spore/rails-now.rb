# If you use gems that require environment variables to be set before they are
# loaded, then list `spore-rails` in the `Gemfile` before those other gems and
# require `spore/rails-now`.
#
#     gem "spore-rails", :require => "spore/rails-now"
#     gem "gem-that-requires-env-variables"
#

require "spore/rails"
Spore::Railtie.load
