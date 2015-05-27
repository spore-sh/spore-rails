require 'json'

module Spore
  class Parser
    class << self
      def call(string)
        JSON.parse(string)
      end
    end

    def initialize(string)
      @string = string
      @hash = {}
    end

    def call
      @string.split("\n").each do |line|
        parse_line(line)
      end
      @hash
    end
  end
end
