require 'spore-api'

module Spore
  class Config
    attr_reader :app_id
    attr_reader :environment
    attr_reader :api

    DEPLOYMENT_VAR = "SPORE_DEPLOYMENT"

    class << self
      def is_deployment?
        !ENV[DEPLOYMENT_VAR].nil?
      end

      def load
        if is_deployment?
          Spore::DeploymentConfig.new
        else
        end
      end
    end

    def fetch(cell_id)
      api.get_cell(app_id, environment, cell_id)["value"]
    end
  end
end

module Spore
  class DeploymentConfig < Config
    attr_reader :login
    attr_reader :key
    attr_reader :app_id
    attr_reader :environment
    attr_reader :host

    ENV_FORMAT = /(http|https):\/\/([a-zA-Z0-9-]+)\+([a-zA-Z0-9-]+)\+([a-f0-9-]+):([^@]+)@(.+)/
    
    def initialize
      ENV_FORMAT.match(ENV[Config::DEPLOYMENT_VAR]) do |m|
        @name = m[2]
        @environment = m[3]
        @app_id = m[4]
        @key = m[5]
        @host = "#{m[1]}://#{m[6]}"
        @api = Spore::Client.new
        @api.key = @key
        @api.name = @name
      end
      raise "SPORE_DEPLOYMENT has an unexpected format" if @name.nil?
    end
  end
end