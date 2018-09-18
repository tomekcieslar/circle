class Line
  InvalidFormat = Class.new(StandardError)

  def initialize(source)
    raise('Line is an abstract class and cannot be instantiated.') unless self.class < Line

    @source = source
    validate_format!
  end

  def self.parse(source)
    raise ArgumentError, 'you need to provide a string as an argument' if source.nil?

    if Header::REGEX.match?(source)
      Header.new(source)
    elsif ChecklistItem::REGEX.match?(source)
      ChecklistItem.new(source)
    else
      Text.new(source)
    end
  end

  private

  attr_reader :source

  def validate_format!
    true
  end

  def source_match
    @source_match ||= source.match(self.class.const_get('REGEX'))
  end
end
