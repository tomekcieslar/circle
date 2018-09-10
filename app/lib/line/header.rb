class Line::Header < Line
  def initialize(source)
    if source  =~  /\s*#+\s*(?<subject>.*)/ && !source.match(/\s*#+\s*(?<subject>.*)/)[:subject].empty?
      @source = source
    else
      raise InvalidFormat
    end
  end

  def to_s
    source.match(/\s*#+\s*(?<subject>.*)/)[:subject]
  end

  def nesting
    source.count("#")
  end

  private
  attr_reader :source
end
