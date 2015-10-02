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
      each { |k, v| ENV[k] ||= Substitutions.call(v) }
    end

    def apply!
      each { |k, v| ENV[k] = Substitutions.call(v) }
    end

    class Substitutions
      PATTERN = /
        (?<escape>\\?)
        \$
        (?<ocurl>\{?)
        (?<variable>[A-Z0-9_]+)
        (?<ccurl>\}?)
      /xi

      def self.call(value)
        value.gsub(PATTERN) do |variable|
          replace(variable, variable.match(PATTERN))
        end
      end

      private_class_method def self.replace(value, match)
        return value[1..-1] unless match[:escape].empty?
        return value[1..-1] unless match[:ocurl].empty? == match[:ccurl].empty?
        ENV[match[:variable]]
      end
    end
  end
end
