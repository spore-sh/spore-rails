require "spore/parser"
require "spore/environment"
require "spore/config"

# The top level Spore module. The entrypoint for the application logic.
module Spore
  class << self
    attr_accessor :instrumenter
  end

  module_function

  def load(*filenames)
    env = Environment.new
    instrument("spore.load", :env => env) { env.apply }
  end

  # same as `load`, but will override existing values in `ENV`
  def overload(*filenames)
    env = Environment.new
    instrument("spore.overload", :env => env) { env.apply! }
  end

  def instrument(name, payload = {}, &block)
    if instrumenter
      instrumenter.instrument(name, payload, &block)
    else
      block.call
    end
  end
end
