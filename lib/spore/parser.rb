require 'json'

module Spore
  class Parser
    class << self
      def call(string)
        config = Spore::Config.load
        new(string, config).hash
      end
    end

    attr_reader :hash
    def initialize(string, config)
      @config = config
      translate(JSON.parse(string)["envs"][config.environment])
    end

    def translate(hash)
      @hash = {}
      hash.each do |key, value|
        @hash[key] = @config.fetch(value)
      end
      @hash
    end
  end
end
