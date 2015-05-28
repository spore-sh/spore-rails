module Spore
  # This class inherits from Hash and represents the environemnt into which
  # Dotenv will load key value pairs from a file.
  class Environment < Hash
    attr_reader :filename

    def initialize
      load
    end

    def load
      update Parser.call
    end

    def read
      File.read(@filename)
    end

    def apply
      each { |k, v| ENV[k] ||= v }
    end

    def apply!
      each { |k, v| ENV[k] = v }
    end
  end
end
