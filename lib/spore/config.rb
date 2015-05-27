require 'spore-api'
require 'netrc'

module Spore
  class Config
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
          Spore::LocalConfig.new
        end
      end
    end

    def fetch(app_id, cell_id)
      api.get_cell(app_id, environment, cell_id)["value"]
    end
  end
end

module Spore
  class LocalConfig < Config
    CONFIG_FILE = "config.json"
    DEFAULT_CONFIG = "./lib/config/default.json"

    def initialize
      @config = load_config
      email, key = load_credentials
      @api = Spore::Client.new
      @api.key = key
      @api.name = email
      @api.api_endpoint = server
    end

    def environment
      ENV["RAILS_ENV"] || @config["defaultEnv"]
    end

    def server
      @config["useProxy"] ? "http://127.0.0.1:#{@config["proxy"]["port"]}" : @config["host"]
    end

    private

    def load_credentials
      n = Netrc.read(File.expand_path @config["netrc"])
      hostname = URI.parse(@config["host"]).hostname
      n[hostname]
    end

    def load_config
      file = File.read DEFAULT_CONFIG
      hash  = JSON.parse file
      config_file = File.join(ENV["SPORE_HOME"] || "~/.spore", CONFIG_FILE)
      begin
        hash.update(JSON.parse(File.read(File.expand_path(config_file))))
      rescue Errno::ENOENT
        # ~/.spore/config.json doesn't exist, so just use the default config
        hash
      end
    end
  end
end

module Spore
  class DeploymentConfig < Config
    ENV_FORMAT = /(http|https):\/\/([a-zA-Z0-9-]+)\+([a-zA-Z0-9-]+)\+([a-f0-9-]+):([^@]+)@(.+)/

    def initialize
      ENV_FORMAT.match(ENV[Config::DEPLOYMENT_VAR]) do |m|
        @name = m[2]
        @environment = m[3]
        @key = m[5]
        @host = "#{m[1]}://#{m[6]}"
        @api = Spore::Client.new
        @api.key = @key
        @api.name = @name
        @api.api_endpoint = @host
      end
      raise "SPORE_DEPLOYMENT has an unexpected format" if @name.nil?
    end
  end
end