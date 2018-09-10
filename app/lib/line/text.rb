class Line::Text < Line
  def initialize(source)
    @source = source
  end

  def to_s
    source
  end

  private
  attr_reader :source
end
