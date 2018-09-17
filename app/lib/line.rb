class Line
  NotImplementedError = Class.new(StandardError)
  InvalidFormat = Class.new(StandardError)

  def initialize(source)
    @source = source
    validate_format!
  end

  def self.parse(source)
    raise ArgumentError, 'you need to provide a string as an argument' if source.nil?

    if Header::HEADER_REGEX.match?(source)
      Header.new(source)
    elsif ChecklistItem::CHECKLIST_ITEM_REGEX.match?(source)
      ChecklistItem.new(source)
    else
      Text.new(source)
    end
  end

  def validate_format!
    raise(NotImplementedError, 'Line is an abstract class and cannot be instantiated.') \
    if self.class.to_s == 'Line'
  end

  private

  attr_reader :source
end
