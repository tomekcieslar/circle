class Line
  class ChecklistItem < Line
    CHECKLIST_ITEM_REGEX = /\s*\[(?<checked>[x\s])\]\s*(?<item>.*)/

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

    def validate_format!
      raise InvalidFormat if source !~ CHECKLIST_ITEM_REGEX || source_match[:item].empty?
    end

    private

    def source_match
      @source_match ||= source.match(CHECKLIST_ITEM_REGEX)
    end
  end
end
