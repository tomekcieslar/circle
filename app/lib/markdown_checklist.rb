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
    parsed_line = Line.parse(line)
      if parsed_line.kind_of?(Line::ChecklistItem)
        raise DuplicateItemNames   if items.has_key?(parsed_line.to_s)

        items.merge!(parsed_line.to_s => parsed_line.checked?)
      elsif parsed_line.kind_of?(Line::Header)
        raise DuplicateSubjectNames if subject.include?(parsed_line.to_s)

        if !items.empty?
          yield subject, items
          items.clear
        end
        if line.count("#") > subject.count + 1
          subject << parsed_line.to_s
        elsif parsed_line.nesting == subject.count + 1
          subject.pop if subject.count > 0
          subject.push(parsed_line.to_s)
        else
          (subject.count - line.count("#") + 2).times do
            subject.pop
          end
          subject.push(parsed_line.to_s)
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
