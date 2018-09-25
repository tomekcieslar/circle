class Line
  class Header < Line
    REGEX = /^\s*#+\s*(?<subject>.*)/

    def initialize(source)
      @source = source
      validate_format!
    end

    def to_s
      source_match[:subject]
    end

    def nesting
      source.count('#')
    end

    private

    def validate_format!
      raise InvalidFormat if source !~ REGEX || source_match[:subject].empty?
    end
  end
end
