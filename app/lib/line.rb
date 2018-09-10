class Line
  NotImplementedError = Class.new(StandardError)
  InvalidFormat = Class.new(StandardError)
  
  def initialize(source)
    raise(NotImplementedError, "Line is an abstract class and cannot be instantiated.")
  end

  def self.parse(source)
    raise ArgumentError, "you need to provide a string as an argument" if source.nil?

    if source =~ /\s*#+\s*(?<subject>.*)/
       Header.new(source)
    elsif source =~ /\s*\[[x\s]\]\s*(?<item>.*)/
      ChecklistItem.new(source)
    else
      Text.new(source)
    end
  end

  private
  attr_reader :source
end
