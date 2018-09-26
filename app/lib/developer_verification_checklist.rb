class DeveloperVerificationChecklist
  include Enumerable
  LEVEL_SYMBOL_MAPPING =
    { independent: :small_blue_diamond, mid: :small_orange_diamond, senior: :small_red_triangle }
  EMOJI_REGEX = /:[a-z_]+:/

  def initialize(markdown_checklist_statistics, level)
    @markdown_checklist_statistics = markdown_checklist_statistics
    @level = level
  end

  def each
    markdown_checklist_statistics.each do |subjects, statistics, items|
      subjects.map! do |subject|
          subject.sub(EMOJI_REGEX, '').squish
      end.compact
      missing_required_tasks = items.map do |item_label, is_checked|
        if !is_checked && item_label[":#{LEVEL_SYMBOL_MAPPING[level]}:"]
          item_label.gsub(EMOJI_REGEX, '').squish
        end
      end.compact
      missing_required_tasks_count = { missing_required_tasks: missing_required_tasks.count }
      statistics.merge!(missing_required_tasks_count)
      yield subjects, statistics, missing_required_tasks
    end
  end

  private

  attr_reader :markdown_checklist_statistics, :level
end
