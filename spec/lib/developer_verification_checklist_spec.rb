require 'rails_helper'

RSpec.describe DeveloperVerificationChecklist do
  describe '#each' do
    describe 'statistics (2nd block value)' do
      it 'includes amount of missing required checklist items
      for given level identified by LEVEL_SYMBOL_MAPPING' do
        stub_const(
          'DeveloperVerificationChecklist::LEVEL_SYMBOL_MAPPING',
          independent: :small_blue_diamond
        )
        markdown_checklist_statistics = instance_double(MarkdownChecklistStatistics)

        allow(MarkdownChecklistStatistics).to receive(:new) { markdown_checklist_statistics }
        allow(markdown_checklist_statistics).to receive(:each)
          .and_yield(
            ['Home'],
            { total: 5, checked: 2 },
            'Plants :small_orange_diamond: ' => false, 'Rooms :small_blue_diamond: wow' => true,
            'Furniture and desk :small_blue_diamond: ' => false,
            'Floors & Doors  :small_blue_diamond: first' => false, 'Garden' => true
          )
        developer_verification_checklist =
          DeveloperVerificationChecklist.new(markdown_checklist_statistics, :independent)

        expect { |b| developer_verification_checklist.each(&b) }.to \
          yield_with_args(
            ['Home'], { total: 5, checked: 2, missing_required_tasks: 2 }, kind_of(Array)
          )
      end
    end

    describe 'missing_required_tasks (3rd block value)' do
      it 'includes all missing required checklist items' do
        stub_const(
          'DeveloperVerificationChecklist::LEVEL_SYMBOL_MAPPING',
          mid: :small_orange_diamond
        )
        markdown_checklist_statistics = instance_double(MarkdownChecklistStatistics)

        allow(MarkdownChecklistStatistics).to receive(:new) { markdown_checklist_statistics }
        allow(markdown_checklist_statistics).to receive(:each)
          .and_yield(
            ['Home'],
            { total: 5, checked: 2 },
            'Plants :small_orange_diamond:' => false, 'Rooms :small_blue_diamond: wow' => true,
            'Furniture and desk :small_blue_diamond:' => false,
            'Floors & Doors :small_blue_diamond: first' => false,
            'Garden' => true
          )
        developer_verification_checklist =
          DeveloperVerificationChecklist.new(markdown_checklist_statistics, :mid)

        expect { |b| developer_verification_checklist.each(&b) }.to \
          yield_with_args(
            ['Home'],
            { total: 5, checked: 2, missing_required_tasks: 1 },
            ['Plants']
          )
      end
    end
  end

  describe 'LEVEL_SYMBOL_MAPPING' do
    it 'defines mapping between emoji symbol and given verification level' do
      expect(DeveloperVerificationChecklist::LEVEL_SYMBOL_MAPPING).to eq(
        independent: :small_blue_diamond, mid: :small_orange_diamond, senior: :small_red_triangle
      )
    end
  end
end
