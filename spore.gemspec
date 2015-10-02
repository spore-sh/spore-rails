require File.expand_path("../lib/spore/version", __FILE__)
require "English"

Gem::Specification.new "spore", Spore::Version do |gem|
  gem.authors       = ["Shayan Guha"]
  gem.email         = ["shayan@teleborder.com"]
  gem.description   = gem.summary = "Loads environment variables from spore."
  gem.homepage      = "https://github.com/spore-sh/spore-rails"
  gem.license       = "MIT"

  gem.files = %w(LICENSE README.md Rakefile spore.gemspec)
  gem.files += Dir.glob("lib/**/*.rb")
  gem.require_paths = ["lib"]
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }

  gem.add_dependency "spore-api", "~> 0.0"
  gem.add_dependency "netrc", "~> 0.10"

  gem.add_development_dependency "bundler", ">= 1.6.9"
  gem.add_development_dependency "byebug"
  gem.add_development_dependency "rake", ">= 10.3"
end
