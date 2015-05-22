require File.expand_path("../lib/spore/version", __FILE__)
require "English"

Gem::Specification.new "spore", Spore::Version do |gem|
  gem.authors       = ["Shayan Guha"]
  gem.email         = ["shayan@teleborder.com"]
  gem.description   = gem.summary = "Loads environment variables from spore."
  gem.homepage      = "https://github.com/Teleborder/spore-rails"
  gem.license       = "MIT"

  gem.files         = `git ls-files README.md LICENSE lib bin | grep -v rails`
    .split($OUTPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }

  gem.add_dependency 'spore-api', "~> 0.0.1"
end
