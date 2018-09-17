class Line
  class Header < Line
    HEADER_REGEX = /\s*#+\s*(?<subject>.*)/

    def initialize(source)
      @source = source
      validate_format!
    end

    def to_s
      source.match(HEADER_REGEX)[:subject]
    end

    def nesting
      source.count('#')
    end

    def source_match
      @source_match ||= source.match(HEADER_REGEX)
    end

    private

    def validate_format!
      raise InvalidFormat if source !~ HEADER_REGEX || source.match(HEADER_REGEX)[:subject].empty?
    end
  end
end
