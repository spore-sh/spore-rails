require 'json'

module Spore
  class Parser
    class << self
      def call
        config = Spore::Config.load
        new(config).hash
      end
    end

    attr_reader :hash
    def initialize(config)
      @config = config
      spore = JSON.parse(File.read config.spore_file)
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
