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
      spore = JSON.parse(string)
      translate(spore["id"], spore["envs"][config.environment])
    end

    def translate(app_id, hash)
      @hash = {}
      hash.each do |key, value|
        @hash[key] = @config.fetch(app_id, value)
      end
      @hash
    end
  end
end
