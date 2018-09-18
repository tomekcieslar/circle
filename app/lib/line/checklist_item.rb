class Line
  class ChecklistItem < Line
    REGEX = /\s*\[(?<checked>[x\s])\]\s*(?<item>.*)/

    def initialize(source)
      @source = source
      validate_format!
    end

    def to_s
      source_match[:item]
    end

    def checked?
      source_match[:checked].include?('x')
    end

    private

    def validate_format!
      raise InvalidFormat if source !~ REGEX || source_match[:item].empty?
    end
  end
end
