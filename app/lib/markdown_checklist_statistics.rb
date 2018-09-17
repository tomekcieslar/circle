class MarkdownChecklistStatistics
  def initialize(markdown_checklist)
    @markdown_checklist = markdown_checklist
  end

  def each
    markdown_checklist.each do |subject, items|
      statistics = { total: items.count, checked: \
      items.count { |_item_name, is_completed| is_completed } }
      yield subject, statistics
    end
  end

  private

  attr_reader :markdown_checklist
end
