class MarkdownChecklistStatistics

  def initialize(markdown_checklist)
    @markdown_checklist = markdown_checklist
  end

  def each
    markdown_checklist.each do |subject, items|
      statistics = {total: items.count, checked: items.select {|k,v| v== true }.count }
      yield subject, statistics
    end
  end

  private
  attr_reader :markdown_checklist
end
