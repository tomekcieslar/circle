class MarkdownChecklist
  DuplicateSubjectNames = Class.new(StandardError)
  DuplicateItemNames = Class.new(StandardError)

  def initialize(source)
    @source = source
  end

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/MethodLength, Metrics/PerceivedComplexity
  def each
    items = {}
    subject = []
    source.each_line do |line|
      parsed_line = Line.parse(line)
      if parsed_line.is_a?(Line::ChecklistItem)
        raise DuplicateItemNames if items.key?(parsed_line.to_s)

        items.merge!(parsed_line.to_s => parsed_line.checked?)
      elsif parsed_line.is_a?(Line::Header)
        raise DuplicateSubjectNames if subject.include?(parsed_line.to_s)

        unless items.empty?
          yield subject, items
          items.clear
        end
        if line.count('#') > subject.count + 1
          subject << parsed_line.to_s
        elsif parsed_line.nesting == subject.count + 1
          subject.pop if subject.count.positive?
          subject.push(parsed_line.to_s)
        else
          (subject.count - line.count('#') + 2).times do
            subject.pop
          end
          subject.push(parsed_line.to_s)
        end
      end
    end

    unless items.empty?
      yield subject, items
      items.clear
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/MethodLength, Metrics/PerceivedComplexity

  private

  attr_reader :source
end
