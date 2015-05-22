module Spore
  class Version
    MAJOR = 0
    MINOR = 0
    PATCH = 1

    class << self
      def to_s
        [MAJOR, MINOR, PATCH].join('.')
      end
    end
  end
end