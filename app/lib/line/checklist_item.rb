class Line::ChecklistItem < Line
  def initialize(source)
    if source =~ /\s*\[[x\s]\]\s*(?<item>.*)/ && !source.match(/\s*\[[x\s]\]\s*(?<item>.*)/)[:item].empty?
      @source = source
    else
      raise InvalidFormat
    end
  end

  def to_s
    source.match(/\s*\[[x\s]\]\s*(?<item>.*)/)[:item]
  end

  def checked?
     source.match(/\s*\[(?<checked>[x\s])\]\s*.*/)[:checked].include?("x")
  end
end
