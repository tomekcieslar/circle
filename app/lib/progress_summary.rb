class ProgressSummary
  def initialize(url:, level:)
    @url = url
    @level = level.to_sym
  end

  def total_selected
    developer_verification_checklist.sum do |_subject, statistics, _missing_required_tasks|
      statistics[:checked]
    end
  end

  def total
    developer_verification_checklist.sum do |_subject, statistics, _missing_required_tasks|
      statistics[:total]
    end
  end

  def subjects
    developer_verification_checklist
  end

  def rendering(argument)
    markdown.render(argument).html_safe
  end

  private

  def markdown
    Redcarpet::Markdown.new(ChecklistRenderer, fenced_code_blocks: true)
  end

  def source
    GetGistMarkdown.call(url)
  end

  def markdown_checklist
    MarkdownChecklist.new(source)
  end

  def markdown_checklist_statistics
    MarkdownChecklistStatistics.new(markdown_checklist)
  end

  def developer_verification_checklist
    DeveloperVerificationChecklist.new(markdown_checklist_statistics, level)
  end

  attr_reader :url, :level
end
