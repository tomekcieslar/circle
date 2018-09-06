class MarkdownChecklist
  DuplicateSubjectNames = Class.new(StandardError)
  DuplicateItemNames = Class.new(StandardError)

  def initialize(source)
    @source = source
  end

  def each
    items = {}
    subject = []
    source.each_line do |line|
      if line =~ /\s*\[[x\s]\]\s*(?<item>.*)/
        if items.has_key?(line.match(/\s*\[[x\s]\]\s*(?<item>.*)/)[:item])
          raise DuplicateItemNames
        end
        items.merge!(line.match(/\s*\[[x\s]\]\s*(?<item>.*)/)[:item] => line.match(/\s*\[(?<checked>[x\s])\]\s*(?<item>.*)/)[:checked].present?)
      elsif line =~ /\s*#+\s*(?<subject>.*)/
        if subject.include?(line.match(/\s*#+\s*(?<subject>.*)/)[:subject])
          raise DuplicateSubjectNames
        end
        if !items.empty?
          yield subject, items
          items.clear
        end
        if line.count("#") > subject.count + 1
          subject << line.match(/\s*#+\s*(?<subject>.*)/)[:subject]
        elsif line.count("#") == subject.count + 1
          if subject.count > 0
            subject.pop
          end
          subject.push(line.match(/\s*#+\s*(?<subject>.*)/)[:subject])
        else
          (subject.count - line.count("#") + 2).times do
            subject.pop
          end
          subject.push(line.match(/\s*#+\s*(?<subject>.*)/)[:subject])
        end
      end
    end

    if !items.empty?
      yield subject, items
      items.clear
    end
  end

  private
    attr_reader :source
end
